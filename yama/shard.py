import config
import database

# Eg: shards= { 3: ('db_node3','url_s3'), 1: ('db_node1','url_s1'), 2:('db_node2','url_s2') }

def load_shard_dict():
    conf = config.get_config()
    db = database.connect_db(conf['shard_db_hostname'])
    cur = db.cursor()
    cur.execute("SELECT * from shards;")
    shards= {}
    row = cur.fetchone()
    while row is not None:
        #set the node hostname
        shards[int(row[0])] = (row[1],row[2])
        row = cur.fetchone()
    cur.close()
    db.close()
    return shards

"""
Hash function for shading scheme
returns hostname and table_name
"""

def get_shard(shards, url):
    return shards[hash(str(url['hostname'])+str(url['port'])+str(url['path'])) % len(shards)]

