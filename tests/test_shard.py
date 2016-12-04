import unittest

from yama import shard

class TestGetShard(unittest.TestCase):

    def test_type_errors(self):
        shards= { 0: ('db_node0','url_s0'), 1: ('db_node1','url_s1'), 2:('db_node2','url_s2') }
        url = { "hostname": 'www.google.es', "port": 80, "path": '/path/to/something' }

        with self.assertRaises(TypeError):
            shard.get_shard(shards, 'hola')
            shard.get_shard(12, url)

    def test_zero_key(self):
        shards = { 1: 'first' , 2: 'second' }
        url = { "hostname": 'www.google.es', "port": 80, "path": '/path/to/something' }

        with self.assertRaises(KeyError):
            shard.get_shard(shards, url)


if __name__ is '__main__':
    unittest.main()

