# Y.A.M.A.

Yet Another Malware Analyzer

Simple web service which maintains several databases with malware URL list and retrieve if it's malware or not.


## INSTALL 

Requirements: Debian 8 Jessie and python 2.7.9

- clone the repo and install puppet client

```
apt-get install git
git clone http://github.com/vitovitolo/yama
apt-get install puppet 
```

This will install some python modules in your system without virtualenv:

- bottle 0.12.7
- yaml 3.11
- mysqldb 1.2.3
- redis 2.10.5

You have different install methods:

### yama node

This will install only the yama web server

```
puppet apply --modulepath puppet/modules/ puppet/manifests/yama.pp
```

### external load balancer

Install HAProxy load balancer with two yama servers configured
```
puppet apply --modulepath puppet/modules/ puppet/manifests/load_balancer.pp
```


### whole system (recomended for testing)

Install HAProxy load balancer with two yama servers configured. Install MySQL server with yama SQL schemas and redis as a cache.

```
puppet apply --modulepath puppet/modules/ puppet/manifests/all.pp
```

DESIGN
===

[Read the design](docs/design.md)


TODO
===

- More unit tests
- Install python modules as virtualenvs
- Choose a better cache policy: add TTL in each url read / LRU / etc
- Add a properly python logging module
- Add a puppet module for datastore load balancer
- Add to puppet mysql replication config
- Shard node addition and auto resharding
