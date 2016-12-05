#!/usr/bin/env python

from setuptools import setup

setup(name='yama',
      version='0.1.0',
      description='Yet Another Malware Analyzer',
      author='Victor Torre',
      author_email='victor.torre@gmail.com',
      url='https://github.com/vitovitolo/yama',
      packages=['yama'],
      license='LICENSE.txt',
      install_requires=['bottle>=0.12', 'pyyaml>=3.11', 'mysql-python>=1.2.3'],
     )
