Docker Tutorial
===============

The Docker tutorial is an interactive learning environment to get familiar with the Docker commandline.


Simple Usage
------------

Generally this application is used in the www.docker.io website. It's source can be found on
https://github.com/dotcloud/www.docker.io/. By installing that you will get this app 'for free' as a
dependency.

However, this app is made to also be usable inside other Django applications. All that is required is to
add git+https://github.com/dhrp/docker-tutorial.git#egg=DockerTutorial-dev to your requirements.txt
and it will be installed by pip upon pip install -r requirements.txt

To include it
* Make sure your "host" app uses the same python environment
* In your "host" app settings include "docker_tutorial"
* in a template {% include 'tutorial/snippet.html' %}
* in your urls.py add url(r'^tutorial/', include('docker_tutorial.urls')),
* in your settings make sure you include the session middleware:


When you want to make changes
-----------------------------

* First create or switch to a virtual environment in which you have the "host" app into which you would
    like to embed the tutorial. e.g. a clone of the the Docker website (before you ran install)
* Clone this repository:
    git clone https://github.com/dhrp/docker-tutorial.git
* Switch to the dir:
    cd docker-tutorial
* Install the application with the -e (editable) flag.
    pip install -e .

This will setup the symlinks such that you don't need to run setup.py every time you want to see a
change. i.e. your local repository is now linked into the environment.

Running the unit tests
----------------------

* ./runtests.py

Running code coverage
---------------------

* coverage run ./runtests.py && coverage html --include="./docker_tutorial/*"

Happy coding!