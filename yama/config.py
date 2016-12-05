import os.path
import yaml

CONFIG_FILE='/etc/yama/config.yaml'

def get_config():
    try:
        return yaml.safe_load(open(CONFIG_FILE))
    except Exception as e:
        print e

def check_config():
    try:
        conf = yaml.safe_load(open(CONFIG_FILE))
    except Exception as e:
        return False
    return True

