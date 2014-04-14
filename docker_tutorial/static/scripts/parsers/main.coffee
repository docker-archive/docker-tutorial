###
  Main Docker command parser
###

define ['require', 'parsers/run', 'parsers/utils'], ( require, DockerRun, utils ) ->

  class Parser
    parser: {}
    input: []
    term: {}
    args: {}

    constructor: (@input, @term) ->

      SWITCHES = [
        ['-H', '--H', '[unix:///var/run/docker.sock]: tcp://host:port to bind/connect to or unix://path/to/socket to use'],
      ]
      @optparser = new optparse.OptionParser(SWITCHES)
      @optparser.banner =
      """
      Usage: docker [OPTIONS] COMMAND [arg...]
      """

      @optparser.on(1, (value) =>
        console.log @args
        @args.command = value
        return
      )
      @optparser.on(2, (value) =>
        if @args.command is 'search'
          @args.search_term = value
          return
      )

      @optparser.parse(input)
      return this


    run: () ->
      ### Delegates to other command parsers ###
      if @args.command is 'run'
        runner = new DockerRun(@input, @term)
        result = runner.run()
        return result

#        return new DockerRun(@input, @term).run()

      if @args.command is 'push'
        return docker_push(ARGS)

      if @args.command is 'pull'
        return docker_pull(ARGS)

      ### simple 'local' parsers ###
      if @args.command is 'test'
        @term.echo utils.timestamp

      if @args.command is 'version'
        @term.echo docker_version()
        return {'answered': 'docker-version'}

      if @args.command is 'search' and @args.search_term not in ['tutorial', 'ubuntu']
        @term.echo search_no_results(@args.search_term)
        return {}

      if @args.command is 'search' and @args.search_term is 'ubuntu'
        @term.echo search_ubuntu()
        return {}

      if @args.command is 'search' and @args.search_term is 'learn'
        @term.echo search_learn()
        return {'answered': 'docker-search'}

      if not @args.command
        @term.echo "A self-sufficient runtime for linux containers."
        @term.echo @optparser.toString()
        return {}


    ###
      Collection of Mock RUN results
    ###

    docker_version = () ->
        """
        Docker Emulator version #{app.EMULATOR_VERSION}

        Emulating:
        Client version: 0.5.3
        Server version: 0.5.3
        Go version: go1.1
        """


    search_no_results = (keyword) ->
      """
      Found 0 results matching your query ("#{keyword}")
      NAME                DESCRIPTION
      """

    search_ubuntu = ->
      """
      NAME                                      DESCRIPTION                                     STARS     OFFICIAL   TRUSTED
      ubuntu                                    General use Ubuntu base image.                  128
      stackbrew/ubuntu                          Barebone ubuntu images                          34
      phusion/baseimage                         A special image that is configured for cor...   31
      crashsystems/gitlab-docker                A trusted, regularly updated build of GitL...   18                   [OK]
      dockerfile/ubuntu                         Trusted Ubuntu (http://www.ubuntu.com/) Build   7                    [OK]
      zsol/haskell-platform-2013.2.0.0          haskell platform on ubuntu precise              7
      cmfatih/dun                               The DUN stack: Docker, Ubuntu, Node.js - [...   6
      yankcrime/owncloud                        ownCloud 6.0 with a MySQL backend, support...   5
      jonsharratt/rails                         Ubuntu 12.04 LTS, Rails 4.0, Ruby 2.0.0-p2...   4
      angelrr7702/ubuntu-13.10-sshd             sshd base on angelrr7702/ubuntu-13.10           4                    [OK]
      cmfatih/phantomjs                         PhantomJS [ phantomjs 1.9.7 , casperjs 1.1...   3                    [OK]
      germandz/ruby_base                        Ubuntu 12.04 with Ruby 2.1 & Bundler 1.5.1      3
      scivm/scientific-python-2.7               Scientific Python 2.7 Ubuntu 12.04- Numpy,...   3                    [OK]
      ubuntu-upstart                                                                            3
      jprjr/stackbrew-node                      A stackbrew/ubuntu-based image for Docker,...   2                    [OK]
      jchavas/saucy-base                        working and tested base Ubuntu 13.10 image      2                    [OK]
      flox/ubuntu-openerp                       Run OpenERP on Ubuntu - February 2014           2
      tutum/ubuntu                              DEPRECATED. Use tutum/ubuntu-saucy instead...   2
      edgester/gerrid runt                      The Gerrit code review system. v2.7 using ...   2
      bradrydzewski/couchdb                     CouchDB versions 1.0, 1.4 and 1.5 running ...   2
      lukasz/docker-scala                       Dockerfile for installing Scala 2.10.3, Ja...   2                    [OK]
      stephens/sshd                             Ubuntu 13.10 with openssh based on the sta...   2
      mbentley/ubuntu-django-uwsgi-nginx                                                        2                    [OK]
      ctlc/buildstep                            Built from source at https://github.com/Ce...   2
      vinothkumar6664/nagios6664                Ubuntu1310 +  Nagios                            2
      allisson/docker-ubuntu                                                                    2                    [OK]
      lgsd/saucy                                Base image for lgsd/docker-base (see https...   2
      deis/base                                 Base Ubuntu 12.04 LTS image for the Deis o...   2                    [OK]

      """

    search_learn = ->
      """
      NAME                            DESCRIPTION                     STARS     OFFICIAL   TRUSTED
      learn/tutorial                                                  2
      """

  return Parser