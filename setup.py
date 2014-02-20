# -*- coding: utf-8 -*-
from setuptools import setup
from setuptools import find_packages

setup(
    name='docker-tutorial',
    version='0.2.1',
    author=u'Thatcher Peskens',
    author_email='thatcher@dotcloud.com',
    packages=find_packages(),
    url='https://github.com/dhrp/docker-tutorial/',
    license='To be determined',
    description='An interactive learning environment to get familiar with the Docker cli',
    long_description=open('README.md').read(),
    include_package_data=True,
)
