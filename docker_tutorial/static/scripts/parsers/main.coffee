###
  Main Docker command parser
###

define ['require', 'settings', 'parsers/utils', 'parsers/run', 'parsers/pull', 'parsers/ps'], ( require, settings, utils, DockerRun, DockerPull, DockerPs) ->

  class Parser
    parser: null
    input: null
    term: null
    args: null

    constructor: (@raw_input, @term) ->

      @parser = {}
      @input = []
      @args = {}

      # Drop all input to lowercase
      for item in @raw_input
        @input.push item.toLowerCase()

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

      @optparser.parse(@input)
      return this


    run: () ->
      ### Delegates to other command parsers ###
      if @args.command is 'run'
        runner = new DockerRun(@input, @term)
        result = runner.run()
        return result

      if @args.command is 'push'
        return docker_push(@input)

      if @args.command is 'pull'
        dockerPull = new DockerPull(@input, @term)
        return dockerPull.run()

      if @args.command is 'ps'
        dockerPs = new DockerPs(@input, @term)
        return dockerPs.run()

      ### simple 'local' parsers ###
      if @args.command is 'time'
        @term.echo utils.timestamp

      if @args.command is 'version'
        @term.echo docker_version(settings.EMULATOR_VERSION)
        return {'answered': 'docker-version'}

      if @args.command is 'search' and @args.search_term not in ['tutorial', 'ubuntu', 'learn']
        @term.echo search_no_results(@args.search_term)
        return {}

      if @args.command is 'search' and @args.search_term is 'ubuntu'
        @term.echo search_ubuntu()
        return {}

      if @args.command is 'search' and @args.search_term is 'tutorial'
        @term.echo search_tutorial()
        return {'answered': 'docker-search'}

      if @args.command is 'search' and @args.search_term is 'learn'
        @term.echo search_learn()

      if not @args.command
        @term.echo "A self-sufficient runtime for linux containers."
        @term.echo @optparser.toString()
        return {}


    ###
      Collection of Mock RUN results
    ###

    docker_version = (version) ->
      """
      Docker Emulator version #{version}

      Emulating:

      Client version: 0.10.0
      Client API version: 1.10
      Go version (client): go1.2.1
      Git commit (client): dc9c28f
      Server version: 0.10.0
      Server API version: 1.10
      Git commit (server): dc9c28f
      Go version (server): go1.2.1
      Last stable version: 0.10.0
      """


    search_no_results = (keyword) ->
      """
      Found 0 results matching your query ("#{keyword}")
      NAME                DESCRIPTION
      """

    search_ubuntu = ->
      """
      NAME                            DESCRIPTION                                     STARS     OFFICIAL   TRUSTED
      ubuntu                          Official Ubuntu base image                      0
      stackbrew/ubuntu                Barebone ubuntu images                          0
      dockerfile/ubuntu               Trusted Ubuntu (http://www.ubuntu.com/) Build   0
      tutum/ubuntu                    DEPRECATED. Use tutum/ubuntu-saucy instead...   0
      cmfatih/ubuntu                  Ubuntu [ ubuntu , vim , htop , zip , wget ...   0
      tutum/ubuntu-quantal            Ubuntu Quantal image with SSH access. For ...   0
      libmesos/ubuntu                                                                 0
      tutum/ubuntu-precise            Ubuntu Precise image with SSH access. For ...   0
      jahkeup/ubuntu                  Ubuntu 13.10 base release                       0
      crohr/ubuntu                    Ubuntu base images. Only lucid (10.04) for...   0
      flox/ubuntu-openerp             Run OpenERP on Ubuntu - April 2014              0
      totem/ubuntu                    A minimal base install of Ubuntu for use i...   0
      markshao/ubuntu                                                                 0
      newsdev/ubuntu                                                                  0
      angelrr7702/ubuntu-13.10-sshd   sshd base on angelrr7702/ubuntu-13.10           0
      vyom/ubuntu                     Ubuntu 14.04 LTS Trusty Base Image for doc...   0
      tianon/ubuntu-core              Ubuntu Core (https://wiki.ubuntu.com/Core)      0
      dpaw/ubuntu                     Ubuntu with AU mirror and universe repo en...   0
      amosrivera/ubuntu               Ubuntu 13.10 with NodeJS, Nginx, Ruby and ...   0
      tutum/ubuntu-saucy              Ubuntu Saucy image with SSH access. For th...   0
      calebcase/ubuntu                Basic Ubuntu Raring image.                      0
      pandrew/ubuntu-lts              https://github.com/pandrew/docker-ubuntu-lts    0
      angelrr7702/ubuntu-13.10        ubuntu 13.10 base to be  use for building ...   0
      jdharrington/ubuntu             The official Docker Ubuntu image with buil...   0
      tithonium/rvm-ubuntu            The base 'ubuntu' image, with rvm installe...   0
      """

    search_learn = ->
      """
      NAME                            DESCRIPTION                                     STARS     OFFICIAL   TRUSTED
      learn/tutorial                  Interactive tutorial                            0
      learn/ping                                                                      0
      nitin/learn_data_science                                                        0
      odewahn/learning-data-science                                                   0
      learndocker/centos              Centos 6.5 base image                           0
      aecc/stream-tree-learning                                                       0
      learndocker/wheezy                                                              0
      shrikar/machinelearning         Get started with machine learning in python     0
      qbyt/sklearn                                                                    0
      greglearns/ruby                 Installs Ruby 2.0.0-p247, RubyGems, and Bu...   0
      parente/ipython-notebook        IPython Notebook plus pandas, matplotlib, ...   0
      greglearns/dietfs               As defined in: http://blog.docker.io/2013/...   0
      greglearns/pglite               As defined in: http://blog.docker.io/2013/...   0
      anychartlearning/test                                                           0
      btel/python3                    basic scientiic environment with python 3....   0
      shreyask/mlnotebook             Machine Learning Notebook.                      0
      turnkeylinux/canvas-13.0        TurnKey Canvas LMS - Learning Management S...   0
      lukec/redis                     Learning how to use docker, created a simp...   0
      clairvy/railsgirls              learning Docker. ex. Rails Girls.               0
      vigsterkr/shogun                The SHOGUN Machine Learning Toolbox http:/...   0
      afolarin/ubuntu_ssh             Ubuntu Image + openssh-server Something of...   0
      """

    search_tutorial = ->
      """
      NAME                           DESCRIPTION                                     STARS     OFFICIAL   TRUSTED
      learn/tutorial                 Interactive tutorial                            0
      zqhxuyuan/tutorial                                                             0
      mzdaniel/buildbot-tutorial                                                     0
      jbarbier/tutorial1                                                             0
      fvieira/node_game_tutorial                                                     0
      odewahn/parallel_ml_tutorial                                                   0
      mhubig/echo                    Simple echo loop from the tutorial.             0
      ivarvong/redis                 From the redis tutorial. Just redis-server...   0
      danlucraft/postgresql          Postgresql 9.3, on port 5432, un:docker, p...   0
      programster/mumble-server      Docker build for running own mumble servic...   0
      namin/io.livecode.ch           interactive programming tutorials, powered...   0
      amattn/postgresql-9.3.0        precise base, PostgreSQL 9.3.0 installed w...   0
      """


  return Parser