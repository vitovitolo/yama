"""
    update module defines addition and deletion operations
"""


import database

def compose_add_response(is_inserted=False):
    response = { "status": str(is_inserted) }
    return response

def add_url(url, db_hostname, table_name):
    is_inserted = database.insert_url(url, db_hostname, table_name)
    # TODO: If not updated, raise 501 or 502 HTTP codes 
    return compose_add_response(is_inserted)
