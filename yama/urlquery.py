"""
    urlquery module
"""

import cache
import database


def compose_response(is_malware=False):
    response = { "malware" : str(is_malware) }
    return response

def exists_in_cache(url, cache_hostname):
    return cache.exists(url, cache_hostname)

def exists_in_database(url, db_hostname, table_name):
    is_malware = database.query_url(url, db_hostname, table_name)
    if is_malware:
        return True
    else:
        return False

def write_to_cache(url, hostname):
    return cache.write(url, hostname)
    
def delete_from_cache(url, hostname):
    return cache.delete(url, hostname)
    
def process_url(url, hostname, table_name):
    if exists_in_cache(url, hostname):
	return compose_response(is_malware=True)
    else:
        is_malware = exists_in_database(url, hostname, table_name)
        if is_malware:
            write_to_cache(url, hostname)
            return compose_response(is_malware)
        else:
            return compose_response(is_malware)

