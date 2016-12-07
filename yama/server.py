#!/usr/bin/env python
# -*- coding: utf-8 -*-


from bottle import Bottle, run, route, response, HTTPResponse

import config
import shard
import update
import urlquery

class Server:
    """
    YAMA Server class based in bottle framework
    Simple and light web service that allows this endpoints:
     /status
     /maintenance
     /urlinfo
     /urlupdate 
    Sharding map and maintenance mode is loaded in constructor method

    """

    def __init__(self, config_file):
        self._app = Bottle()
        self._route()
        self.conf = config.Config(config_file).config
        self.shard_dict = shard.load_shard_from_db(self.conf)
        self.maintenance_mode = False

    def _route(self):
        self._app.route('/status', callback=self._status)
        self._app.route('/maintenance/<action:re:(enable|disable)?>', callback=self._maintenance)
        self._app.route('/urlinfo/1/<hostname>\:<port:int>/<path:re:.*>', callback=self._urlinfo)
        self._app.route('/urlupdate/<operation:re:(add|del)?>/<hostname>\:<port:int>/<path:re:.*>', callback=self._urlupdate)
        self._app.route()

    def _status(self):
        if self.maintenance_mode:
            response.status = 503
            res = { "status": "down for maintenance" }
        else:
            res = { "status": "ok" }
        return res

    def _maintenance(self, action):
        if action == "enable":
            self.maintenance_mode = True 
            res = { "status": "maintenance enabled" }
        elif action == "disable":
            self.maintenance_mode = False 
            res = { "status": "maintenance disabled" }
        return res

    def _urlinfo(self, hostname, port, path):
        url = { "hostname": str(hostname), "port": port, "path": path }
        s = shard.get_shard(self.shard_dict, url)
        res = urlquery.process_url(url, s['hostname'], s['table_name'], self.conf)
        return res

    def _urlupdate(self, operation, hostname, port, path):
        url = { "hostname": str(hostname), "port": port, "path": path }
        s = shard.get_shard(self.shard_dict, url)
        res = update.update_url(url, s['hostname'], s['table_name'], operation, self.conf)
        return res

    def start(self):
        if not self.shard_dict:
            print "Could not load shard map from db"
        else:
            try:
                self._app.run(host=self.conf['host'], port=self.conf['port'])
            except Exception as e:
                print e
