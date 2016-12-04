"""
    urlquery module
"""

import database


def compose_response(is_malware=False):
    response = { "malware" : str(is_malware) }
    return response

def exists_in_cache(url, table_name):
    # TODO: cache_conn = hiredis(...)
    # cache_conn.close()
    return False

def exists_in_database(url, db_hostname, table_name):
    is_malware = database.query_url(url, db_hostname, table_name)
    if is_malware:
        return True
    else:
        return False

def write_to_cache(url, table_name):
    # TODO: cache_conn = hiredis(...)
    # cache_conn.write(url)
    # cache_conn.close()
    print "TODO: write " + str(url['hostname']) + "in cache"
    
def process_url(url, db_hostname, table_name):
    if exists_in_cache(url, table_name):
	return compose_response(is_malware=True)
    else:
        is_malware = exists_in_database(url, db_hostname, table_name)
        if is_malware:
            write_to_cache(url, table_name)
            return compose_response(is_malware)
        else:
            return compose_response(is_malware)

