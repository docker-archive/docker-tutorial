define ['parsers/utils'], (utils) ->


  class DockerPs

    args: null

    constructor: (@input, @term) ->

      @args = {}
#      @args.switch = null

      SWITCHES = [
        ['-a', '--all', 'Show all containers. Only running containers are shown by default'],
        ['--before', 'Show only container created before Id or Name, include non-running ones'],
        ['-l', '--latest', 'Show only the latest created container, include non-running ones'],
        ['-n', '--number NUMBER', 'Show n last created containers, include non running ones'],
        ['--no-trunc', 'Don\'t truncate output'],
        ['-q', '--quiet', 'Only display numeric IDs'],
        ['-s', '--size', 'Display sizes'],
        ['--since', 'Show only containers created since Id or Name, include non-running ones']
      ]

      @optparser = new optparse.OptionParser(SWITCHES)
      @optparser.banner =
      """

      Usage: docker ps [OPTIONS]
      """
      @optparser.options_title = """
      List containers

      """
      ## catch all 'other' options
      @optparser.on( (value) =>
        @args.switch = 'other'
        return {}
      )

      @optparser.on('all', (value) =>
        @args.switch = 'all'
        return {}
      )

      @optparser.on('quiet', (value) =>
        @args.switch = 'quiet'
        return {}
      )

      @optparser.on('latest', (value) =>
        @args.switch = 'latest'
        return {}
      )

      # parse it
      @optparser.parse(@input)

    run: () ->

      if @args.switch is 'other'
        @term.echo @optparser.toString()
        return {}

      if not @args.switch?
        @term.echo ps()
        return ""

      if @args.switch is 'all'
        @term.echo ps_a()
        return {}

      if @args.switch is 'quiet'
        @term.echo ps_quiet()
        return {}

      if @args.switch is 'latest'
        @term.echo ps_latest()
        return {}


    ps = -> """
      CONTAINER ID        IMAGE                    COMMAND                CREATED              STATUS                          PORTS                                          NAMES
      991a00512a73        stackbrew/ubuntu:14.04   apt-get install -y f   12 seconds ago       Exited (0) 5 seconds ago                                                       sharp_ptolemy
      f8a1ef193899        stackbrew/ubuntu:14.04   echo hello world       About a minute ago   Exited (0) About a minute ago                                                  stupefied_darwin
      """

    ps_a = -> """
      CONTAINER ID        IMAGE                    COMMAND                CREATED              STATUS                          PORTS                                          NAMES
      991a00512a73        stackbrew/ubuntu:14.04   apt-get install -y f   12 seconds ago       Exited (0) 5 seconds ago                                                       sharp_ptolemy
      f8a1ef193899        stackbrew/ubuntu:14.04   echo hello world       About a minute ago   Exited (0) About a minute ago                                                  stupefied_darwin
      """

    ps_latest = -> """
      CONTAINER ID        IMAGE                    COMMAND                CREATED              STATUS                          PORTS                                          NAMES
      991a00512a73        stackbrew/ubuntu:14.04   apt-get install -y f   12 seconds ago       Exited (0) 5 seconds ago                                                       sharp_ptolemy
      """

    ps_quiet = -> """
      991a00512a73
      f8a1ef193899
      """

  return DockerPs
