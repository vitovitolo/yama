import MySQLdb

import config

def filter_string(string):
    # TODO
    string_filtered = string
    return str(string)

def connect_db(db_hostname):
    conf = config.get_config()

    try:
        db = MySQLdb.connect(host=str(db_hostname),
                              user=str(conf['db_username']),
                              passwd=str(conf['db_passwd']),
                              db=str(conf['db_name']))
    except Exception as e:
        print e
        return None

    return db


def query_url(url, db_hostname, table_name):
    #Filter strings to trim non-permit chars
    f_hostname = filter_string(url['hostname'])
    f_path = filter_string(url['path'])
    f_table_name = filter_string(table_name)
    # stringify port number
    port = str(url['port'])

    db = connect_db(db_hostname)
    if db == None:
        print "Error connecting database. Exiting.."
        exit(1)
    else:
        cur = db.cursor() 
        c = cur.execute("SELECT is_malware FROM " + f_table_name + 
                        " where hostname='" + f_hostname + 
                        "' and port =" + port + 
                        " and path = '" + f_path + 
                        "' ;")
        if c >= 1:
            row = cur.fetchone()
            cur.close()
            db.close()
            if int(row[0]) >= 1:
                return True
            else:
                return False
        else:
            False

def update_url(url, db_hostname, table_name, operation):
    #Filter strings to trim non-permit chars
    f_table_name = str(table_name)
    f_hostname = filter_string(url['hostname'])
    f_path = filter_string(url['path'])
    # stringify port number
    port = str(url['port'])

    if operation == "add":
        sql = ("INSERT INTO " + f_table_name + 
               " (hostname, port, path) values ('" + 
               f_hostname + "'," + port + ",'" + f_path + "') ;")
    elif operation == "del" :
        sql = ("DELETE FROM " + f_table_name + 
               " where hostname = '" + f_hostname + 
               "' and port = " + port + 
               " and path = '" + f_path + "' ;")
    else:
        return False
    db = connect_db(db_hostname)
    if db == None:
        print "Error connecting database. Exiting.."
        return False
    else:
        cur = db.cursor()
        c = cur.execute(sql) 
        if c>=1:
            cur.close()
            db.commit()
            db.close()
            return True
        else:
            return False


def load_shard(db_hostname):
    """
    Load from Database the shard map structure.
    Returns a dict of dicts with this format:
    shards = { 0: {'hostname': 'db_node0','table_name':'url_s0'}, 1: {'hostname': 'db_node1', 'table_name': 'url_s1'}  }
    On error returns an empty dict 
    """

    shards = {}

    db = connect_db(db_hostname)
    if db == None:
        print "Error connecting database. Exiting.."
        return False
    else:
        cur = db.cursor()
        c = cur.execute("SELECT * from shards;")
        if c>=1:
            row = cur.fetchone()
            while row is not None:
                #composing shards dict
                shards[int(row[0])] = { 'hostname' : row[1], 'table_name': row[2] }
                row = cur.fetchone()
        cur.close()
        db.close()

    return shards 

