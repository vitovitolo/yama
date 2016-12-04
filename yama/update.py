"""
    update module defines addition and deletion operations
"""


import database

def compose_add_response(status=False):
    response = { "status": str(status) }
    return response

def update_url(url, db_hostname, table_name, operation):
    status = database.update_url(url, db_hostname, table_name, operation)
    # TODO
    # Add op: If not updated, raise 501 or 502 HTTP codes 
    # Del op: Delete from all caches 
    return compose_add_response(status)

