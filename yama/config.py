import os.path
import yaml

class Config:
    """
    Configuration class definition
    """
    def __init__(self, config_file):
        self.config_file = config_file
        if self.check_config():
            self.config = self.get_config()

    def get_config(self):
        try:
            return yaml.safe_load(open(self.config_file))
        except Exception as e:
            print e

    def check_config(self):
        try:
            conf = yaml.safe_load(open(self.config_file))
        except Exception as e:
            print "Could not load config file" + str(e)
            exit(1)
            return False
        return True
    

