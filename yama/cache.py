# -*- coding: utf-8 -*-
import config
import redis


def connect_cache(cache_hostname):
    try:
        conn = redis.Redis(cache_hostname)
    except Exception as e:
        print e
        return None
    finally:
        return conn

def hash_url(url):
    return str(str(url['hostname'])+str(url['port'])+str(url['path']))

def write(url, cache_hostname):
    """
    write url in cache before checking its size
    set URL_TTL second TTL in cache for each url
    if cache is full, doesnt write url
    """
    conf = config.get_config()
    #Max number of URL to set in cache
    MAX_URLS=conf['cache_max_urls']
    #Seconds
    URL_TTL=conf['cache_url_ttl']

    cache_db='db0'
    #url dict key validation
    if 'is_malware' not in url:
        url['is_malware'] = 'True'

    conn = connect_cache(cache_hostname)
    if conn is None:
        return False
    else:
        try:
            # Check if cache is full
            redis_info = conn.info()
            if cache_db in redis_info:
                if redis_info[cache_db]['keys'] >= MAX_URLS:
                    cache_full = True
                else:
                    cache_full = False
            else:
                cache_full = False
        except Exception as e:
            print e

        if not cache_full:
            # Set url in cache with TTL
            key_name = hash_url(url)
            status = conn.hmset(key_name, url)
            conn.expire(key_name, URL_TTL)
            return status
        else:
            return False

def delete(url, cache_hostname):
    conn = connect_cache(cache_hostname)
    if conn is not None:
        return conn.delete(hash_url(url))
    else:
        return False

def exists(url, cache_hostname):
    conn = connect_cache(cache_hostname)
    if conn is not None:
        url_cache = conn.hgetall(hash_url(url))
        if url_cache:
            return url_cache['is_malware']
    else:
        return False

def update_url(url, cache_hostname, operation):
    if operation == "add":
        return write(url, cache_hostname)
    elif operation == "del":
        return delete(url, cache_hostname)
    else:
        return False
