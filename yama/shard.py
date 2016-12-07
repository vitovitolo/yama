import database


def load_shard_from_db(conf):
    #TODO: load shard from cache if exists 
    shards = database.load_shard(conf)

    return shards


def get_shard(shards, url):
    """
    Hash function for shading scheme
    returns a dict with hostname and table name
    Eg: s = { 'hostname': 'node1', 'table_name': 'url_s1'}
    """
    if not shards:
        return {}
    else:
        return shards[hash(str(url['hostname'])+str(url['port'])+str(url['path'])) % len(shards)]

