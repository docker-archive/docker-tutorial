# -*- coding: utf-8 -*-
from distutils.core import setup
from setuptools import find_packages

setup(
    name='DockerTutorial',
    version='0.1.2',
    author=u'Thatcher Peskens',
    author_email='thatcher@dotcloud.com',
    packages=find_packages(),
    url='https://github.com/dhrp/docker-tutorial/',
    license='To be determined',
    description='An interactive learning environment to get familiar with the Docker cli',
    long_description=open('README.txt').read(),
    include_package_data=True,
)