import config
import database


def load_shard_from_db():
    """
    Load from Database the shard map structure.
    Returns a dict of dicts with this format:
    shards = { 0: {'hostname': 'db_node0','table_name':'url_s0'}, 1: {'hostname': 'db_node1', 'table_name': 'url_s1'}  }
    On error returns an empty dict 
    """
    conf = config.get_config()
    shards= {}

    try:
        db = database.connect_db(conf['shard_db_hostname'])
        cur = db.cursor()
        cur.execute("SELECT * from shards;")
        row = cur.fetchone()

    except Exception as e:
        print e

    finally:
        while row is not None:
            #composing shards dict
            shards[int(row[0])] = { 'hostname' : row[1], 'table_name': row[2] }
            row = cur.fetchone()
        cur.close()
        db.close()

    return shards


def get_shard(shards, url):
    """
    Hash function for shading scheme
    returns a dict with hostname and table name
    Eg: s = { 'hostname': 'node1', 'table_name': 'url_s1'}
    """
    return shards[hash(str(url['hostname'])+str(url['port'])+str(url['path'])) % len(shards)]

