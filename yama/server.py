#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""

    YAMA HTTP web server based in bottle framework

"""
from bottle import run, route, request

import urlquery

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
    response = urlquery.process_url(url, 'url')
    return response

def start(host, port):
    run(host=host, port=port)

