import unittest

from yama import config

class TestGetConfig(unittest.TestCase):

    def test_get_config_host(self):
        self.assertIsNotNone(config.get_config()['host'])
    def test_get_config_port(self):
        self.assertIsNotNone(config.get_config()['port'])

if __name__ is '__main__':
    unittest.main()

