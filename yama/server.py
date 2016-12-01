#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""

    YAMA HTTP web server based in bottle framework

"""
from bottle import run, route, request

@route('/status')
def status():
   response = { "status": "ok" }
   return response

@route('/reload_config')
def reload_config():
    response = { "status": "config reloaded" }
    return response

@route('/urlinfo/1/<hostname>\:<port:int>/<path_query:re:.*>')
def urlinfo(hostname, port, path_query):
    # we have to split the full path request
    # in order to trim 'urlinfo/1/<hostname>:<port>
    path = str(request.fullpath).split(':',1)[1].split('/',1)[1]
    # The query does not have any character after '#'
    query = str(request.query_string)
    response = { "hostname": str(hostname), "port": port, "full_path": path+"?"+query }
    return response

def start(host, port):
    run(host=host, port=port)

