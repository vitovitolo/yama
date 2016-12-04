import unittest

from yama import urlquery

class TestComposeResponse(unittest.TestCase):

    def test_compose_response_default_return(self):
        self.assertEqual(urlquery.compose_response()['malware'],'False')
    def test_compose_response_true(self):
        self.assertEqual(urlquery.compose_response(True)['malware'],'True')
    def test_compose_response_false(self):
        self.assertEqual(urlquery.compose_response(False)['malware'],'False')

if __name__ is '__main__':
    unittest.main()
