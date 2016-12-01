#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""

    YAMA HTTP web server based in bottle framework

"""

from bottle import run, route

@route('/status')
def status():
   response = { "status": "ok" }
   return response

@route('/reload_config')
def reload_config():
    response = { "status": "config reloaded" }
    return response

def start(host, port):
    run(host=host, port=port)

