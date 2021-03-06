"""
    update module defines addition and deletion URL operations against backends
"""

import cache
import database

def compose_add_response(status=False):
    response = { "status": str(status) }
    return response

def update_url(url, hostname, table_name, operation, conf):
    """
    add or delete URL from database AND cache system
    If one of them fails, returns { 'status': 'False' }
    """
    # Write to different host than read
    if operation == "add":
        db_hostname = conf['write_db_hostname']
    else:
        db_hostname = hostname

    db_status = database.update_url(url, db_hostname, table_name, operation, conf)
    if not db_status:
        return compose_add_response(db_status)
    cache_status = cache.update_url(url, hostname, operation, conf)
    if not cache_status:
        return compose_add_response(cache_status)
    # TODO If not updated in db, raise 501 or 502 HTTP codes 
    return compose_add_response(db_status)

