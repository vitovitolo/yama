#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""

    YAMA HTTP web server based in bottle framework

"""
from bottle import run, route, request

import shard
import update
import urlquery

SHARDS_DICT = shard.load_shard_dict()    

@route('/status')
def status():
   response = { "status": "ok" }
   return response

@route('/reload_config')
def reload_config():
    response = { "status": "config reloaded" }
    return response

@route('/urlinfo/1/<hostname>\:<port:int>/<path:re:.*>')
def urlinfo(hostname, port, path):
    url = { "hostname": str(hostname), "port": port, "path": path }
    host_and_table = shard.get_shard(SHARDS_DICT, url)
    db_hostname = host_and_table[0]
    table_name = host_and_table[1]
    response = urlquery.process_url(url, db_hostname, table_name)
    return response

@route('/addurl/1/<hostname>\:<port:int>/<path:re:.*>')
def add(hostname, port, path):
    url = { "hostname": str(hostname), "port": port, "path": path }
    host_and_table = shard.get_shard(SHARDS_DICT, url)
    db_hostname = host_and_table[0]
    table_name = host_and_table[1]
    response = update.add_url(url, db_hostname, table_name)
    return response
    
def start(host, port):
    run(host=host, port=port)

