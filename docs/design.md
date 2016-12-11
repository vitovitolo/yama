# DESIGN
A prototype of a simple and lightweight web service which checks if a URL is malware or is it safe. This system maintains several databases of malware URL's and help everyone to create a safer Internet. Is it composed of a web service written in bottle framework and different datastores. Yama responds GET requests where the caller passes in a URL and the service responds with some information about that URL.

## HTTP Server
Yama is not more than a simple WSGI single-thread server written in python. It accepts some of GET endpoints describe below 
### /status
Give information about the web service status. 
```
$ curl -X GET "http://localhost/status"
{ “status” : ”ok” }
```
If the server is in maintenance mode returns HTTP 503 Service Unavailable
```
$ curl -X GET "http://localhost/status"
{ “status” : ”down for maintenance” }
```
### /maintenance/[enable|disable]
Set up the server to maintenance mode. This feature only changes the /status endpoint behaviour. The server will continue working as usual if request other endpoints. This is designed to use in a load balancer health check request.
```
$ curl -X GET "http://localhost/maintenance/enable"
{"status": "maintenance enabled"}

$ curl -X GET "http://localhost/maintenance/disable"
{"status": "maintenance disable"}
```
### /urlinfo/1/{hostname}:{port}/{path_and_query}
Check the URL in the datastore of malware list.
```
$ curl -X GET "http://localhost/urlinfo/1/www.google.es:80/search?q=yama"
{“malware”: “False” }
```

This system accepts a URL in this format

 - hostname: it could be an IP address or hostname with limit of 255 characters
 - port: port number of the website. must be 0-65356
 - path_query: full path of the resource without the query string. This field trunk until ‘?’ character in URI string. The root of a website should be “/”.

All fields are mandatory.

### /urlupdate/[add|del]/{hostname}:{port}/{path_and_query}
Execute the operation for the URL in the datastore of malware list.
```bash
$ curl -X GET "http://localhost/urlupdate/add/www.google.es:80/search?q=yama"
{“status”: “True” }
```
This request put that URL in the malware list.
This system accepts a URL in the same format as /urlinfo. All fields are mandatory.
## URL FORMAT
This system store the URL passed in /urlinfo method in a simple structure way to provide scalability:


- hostname: 255 characters
- port: must be 0-65535.
- path: full path of the resource without the query string. This field trunks - ‘path_query’ until ‘?’ character in URI string.
- is_malware: boolean field to set the URL like malware or not


I assume that the query string of the URL is not useful for malware check. When a URL path is malware, every query string again this path it will be processed as malware. 


The ‘is_malware’ boolean field is necessary in order to provide a whitelist feature to the system. This feature is mandatory for the cache level.


Imagine a [common navigation](https://en.wikipedia.org/wiki/List_of_most_popular_websites) URL list like google, facebook, youtube, etc . This kind of URL must be cached in memory to improve the performance and avoid disk operations.

I recommended do not add too much URLs with this value at True in Database storage due to performance issues. The design is to maintains a dataset of URL with malware not without it. In the worst scenario yama needs to execute a full scan to a table in a database. The more dataset you have in this table, the more time to process one URL

## STORAGE
The storage interface for yama is a well-known cache+database environment. The first datastore to ask for is the cache, when the cache does not find that URL, YAMA hit the database and update the cache.

This system may be updated as much as 5 thousand URLs a day in 10 minutes intervals but could grow infinitely. With this premise in mind we have a read scale problem to solve, but with the writes and reads operations divided in different transactions.

### Cache
I need a fast, easy and reliable cache system to store some URL list of malware in memory.
For obvious reasons, in this cache it will be impossible to store all the data set over the years. When a URL is categorized as malware and enter to the system, YAMA check if the cache is full and if not, write it. Every URL in cache system has an expiration time configured in config.yaml file. For this reasons I selected Redis as the cache system.

Yama stored a URL in redis as a hash with the HMSET redis command. The name of the key is the string composed by: hostname+port+path of the URL.

``` bash
$ curl -X GET "http://localhost/urlupdate/add/www.google.es:80/search?q=yama"
{"status": "True"}
```

```bash
$ redis-cli
127.0.0.1:6379> KEYS *
1) "www.google.es80search"
127.0.0.1:6379> HGET "www.google.es80search" hostname
"www.google.es"
127.0.0.1:6379> HGET "www.google.es80search" port
"80"
127.0.0.1:6379> HGET "www.google.es80search" path
"search"
127.0.0.1:6379> TTL "www.google.es80search"
(integer) 94
```

### Database
I need a database to maintains the whole dataset for the system. The decision to use a relational system is not for relational purpose. In fact, the URL list model is denormalized and it seems more to a shared-nothing architecture. 


I rely on MySQL for those other reasons:
- Read scalability
- Master Slave replication scheme
- Robust and mature development
- High performance


Database model of the URL list

| field | data type | values | comments|
|:-----:|:---------:|:------:|--------:|
| id    | integer(1)   | 0-4294967295 | Primary Key, auto increment|
|hostname| varchar(255) | 255 utf-8 chars |
|port  | smallint  | 0-65535 | Default 80 |
|is_malware | boolean | True or False | Default True |


There is no indexes except the primary key. In this model, the indexes can turn against you due to the sharding. Yama insert the URL in the database choosing the hostname and table_name from a Shard Map using a hashing algorithm. If you add an index for the 'hostname' field, nobody assure that you wil have the same websites in the same database table. That doesn’t offer any performance help. Instead of that, the database table size will grow doing the full scan of the table slowest.


The dataset is denormalized to board the sharding scheme. It could appears URL duplicates in the same table but that problem is not solve yet.


I recommended give to the database enough memory to retrieve the whole table in memory/cache. In MySQL InnoDB engine this parameter is innodb_buffer_pool_size


## SHARDING SCHEME
Yama is designed with sharding in mind. Each URL arriving to yama is hashed with URL hostname, URL port and URL path in a modular way with the number of shards of the system.


>  Shard number = HASH(hostname+port+path) MODULE Length(Shards)


The server loads the sharding map from an external database. This sharding map should be over provisioned to avoid future scala problems and complex shard relocation.

### Shard map example
| \# shard |hostname |table_name |
|:--------:|:--------:|:--------|
|0 |node0 |table0 |
|1 |node1 |table2 |
|2 |node0 |table1 |
|3 |node2 |table3 |


Yama can be configured with any shard number but I strongly recommend over provision it. If you start with one server, the hostname of every row could be the same but is it best to create 100 rows in this shard map.

I decided to add a table_name column to provide flexibility moving your dataset. The hash function doesn’t assure that most visited websites like google, facebook, etc, are written in the same shard. With this field you can set up one partition only with the problematic or hottest tables.


Another feature in mind is moving your dataset because a downtime hit one datacenter. You only have to load your backups to another nodes and changed the Shard Map in each yama nodes. 


This design accepts change table_name for database_name. It doesn’t matter if you have a location to search in addition to the hostname.

## ARCHITECTURE
This architecture of a yama system provides high availability, scalability and reliability.


First of all, I decided to use single-thread web service in order to scale it with multiples nodes. In front of this, I will balance the requests with a L7 / L4 balancer (HAproxy) and [anycast](https://en.wikipedia.org/wiki/Anycast) routing method to balance the balancers. 


Each Yama node are almost stateless. They only need the Shard Map of the entire cluster. This information is loaded on startup from an external database. I decided to put in memory this structure for performance reasons.


The next layer will be the Datastore Clusters. Each cluster contains N datastore partition with a database and a memory cache. In front each partition there should be N load balancers. This load balancers uses round-robin to distribute the request and scale the read operations between the datastore partition node. Each cluster contains one data partition and could be replicated the information from the Master Cluster. 

>TODO: diagram


This is the flow for each request asking for a URL


> External LB -> Yama Server -> Datastore LB -> Cache shard -> DB shard *


*Only if the cache system does not have the URL


### Database Replication
This system is designed to be replicated by master-slave. With MySQL you can replicate per table or per database. This provides more flexibility when replicating.

Master Cluster could have all your dataset because I estimated not too much updates in our URL list. Otherwise, the approach will be create one master cluster for each shard.

### Request per second
If yama server reaches the request per second limit you have to add one more yama node in each shard cluster.

### Database read limit
The solution for reaches the read per second limit in the database is add more Database slave nodes in each Datastore Cluster.

### Database write limit
This scenario is more complex but not impossible to board. If the system reaches the write limit, the solution is to divide the Master Cluster in shards. This project doesn’t provide a out-of-the box solution if the system reaches this limit.

###Shard size
In the worst scenario yama needs to execute a full scan to a table in a database. The more dataset you have in this table, the more time to process one URL.

I recommend not to have more than 1 million row in each table. This limit will assure your performance. The over provision described above try to avoid this problem. The recommended number of shard is 1000. With 1 million URLs in each shard and 1000 shards in your massive cluster, you could handle over [1 billion URLs](http://www.internetlivestats.com/total-number-of-websites/). This is approximately the total number of websites on the internet in 2016. 
