import unittest

from yama import database

class TestFilterString(unittest.TestCase):

    def test_return_type(self):
        self.assertEqual(type(database.filter_string('123')),type(''))
    def test_check_casting(self):
        self.assertEqual(type(database.filter_string(123)),type(''))

class TestConnectDb(unittest.TestCase):
    def test_empty_hostname(self):
        self.assertIsNone(database.connect_db(''))

if __name__ is '__main__':
    unittest.main()

