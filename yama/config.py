import os.path
import yaml


def get_config():
    try:
        return yaml.safe_load(open('/etc/yama/config.yaml'))
    except Exception as e:
        print e
        exit(1)

