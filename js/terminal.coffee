###
  Please note the javascript is being fully generated from coffeescript. So make your changes in the .coffee file.
  Thatcher Peskens
###

do @myTerminal = ->

  #  id = terminal

  @basesettings = {
    prompt: 'you@tutorial:~$ ',
    greetings: "Welcome to the interactive Docker tutorial. Enter 'docker' to begin",
  }

  ###
    Callback definitions. These can be overridden by functions anywhere else
  ###

  @preventDefaultCallback = false

  @immediateCallback = (command) ->
    console.debug("immediate callback from #{command}")
    return

  @finishedCallback = (command) ->
    console.debug("finished callback from #{command}")
    return

  @intermediateResults = (string) ->
    console.debug("sent #{string}")
    return

  ###
    Base interpreter
  ###

  @interpreter = (input, term) ->
    inputs = input.split(" ")
    command = inputs[0]

    if command is 'hi'
      term.echo 'hi there! What is your name??'
      term.push (command, term) ->
        term.echo command + ' is a pretty name'

    if command is 'shell'
      term.push (command, term) ->
        term.echo ' is a pretty name'
      , {prompt: '> $ '}

    if command is 'r'
      location.reload('forceGet')

    if command is '#'
      term.echo 'which question?'

    if command is 'cd'
      bash(term, inputs)

    if command is 'exec'
      term.exec (
          "docker run"
      )

    if command is "help"
      term.error 'printing help'
      term.echo '[[b;#fff;]some text]';

    if command is "docker"
      docker(term, inputs)

    if command is "colors"
      for dockerCommand, description of dockerCommands
        term.echo ("[[b;#fff;]" + dockerCommand + "] - " + description + "")

    if command is "pull"
      term.echo '[[b;#fff;]some text]'
      wait(term, 5000, true)
      alert term.get_output()

      return

  #  $('#terminal').terminal( interpreter, basesettings )

    immediateCallback(inputs)


  ###
    Common utils
  ###

  # add beginsWith function to prototype
  String.prototype.beginsWith = (string) ->
    return(this.indexOf(string) is 0)

  #

  util_slow_lines = (term, paragraph, keyword, finishedCallback) ->

    if keyword
      lines = paragraph(keyword).split("\n")
    else
      lines = paragraph.split("\n")

    term.pause()
    i = 0
    # function calls itself after timeout is done, untill
    # all lines are finished
    foo = (lines) ->
      self.setTimeout ( ->
        if lines[i]
          term.echo (lines[i])
          i++
          foo(lines)
        else
          term.resume()
          finishedCallback()
      ), 1000

    foo(lines)


  wait = (term, time, dots) ->
    term.echo "starting to wait"
    interval_id = self.setInterval ( -> dots ? term.insert '.'), 500

    self.setTimeout ( ->
      self.clearInterval(interval_id)
      output = term.get_command()
      term.echo output
      term.echo "done "
    ), time

  ###
    Bash program
  ###

  bash = (term, inputs) ->
    echo = term.echo
    insert = term.insert

    if not inputs[1]

    else
      argument = inputs[1]
      if argument.beginsWith('..')
        echo "-bash: cd: #{argument}: Permission denied"
      else
        echo "-bash: cd: #{argument}: No such file or directory"

  ###
    Docker program
  ###

  docker = (term, inputs) ->

    echo = term.echo
    insert = term.insert
    callback = () -> @finishedCallback(inputs)


    if not inputs[1]
      console.debug "no args"
      echo docker_cmd
      for dockerCommand, description of dockerCommands
        echo "[[b;#fff;]" + dockerCommand + "]" + description + ""

    else if inputs[1] is 'do'
      term.push('do', {prompt: "do $ "})
#      term.pop()

    #### Command run ####

    else if inputs[1] is "run"
      switches = []
      switchArg = false
      switchArgs = []
      imagename = ""
      commands = []
      j = 0

      # parse args
      for input in inputs
        if input.startsWith('-')
          switches.push(input)
          if run_switches[input].length > 0
            switchArg = true
        else if switchArg == true
          # reset switchArg
          switchArg = false
          switchArgs.push(input)
        else if j > 1 and imagename == ""
          # match wrong names
          imagename = input
        else if imagename != ""
          commands.push (input)
        else
          # just docker run

        j++


      parsed_input = {
        'switches': switches.sortBy(),
        'switchArgs': switchArgs,
        'imagename': imagename,
        'commands': commands,
      }

      console.debug JSON.stringify(parsed_input, undefined, 2)

      #check the args
      expected_switches = ['-i', '-t']


      if imagename is "ubuntu"
        console.log("run ubuntu")
        echo run_ubuntu
      else if Object.equal(switches.sortBy(), expected_switches.sortBy())
        if imagename is "learn/tutorial" and commands[0] is "/bin/bash"
          immediateCallback(parsed_input, true)
          term.push (command, term) ->
            term.echo ' is a pretty shell'
          , {prompt: '> $ '}
        else
          intermediateResults(1)
      else if imagename is "learn/tutorial"
        echo run_learn_tutorial
        intermediateResults(0)
      else if imagename
        echo run_notfound(inputs[2])
      else
        console.log("run")
        echo (run_cmd)


    else if inputs[1] is "search"
      if keyword = inputs[2]
        if keyword is "ubuntu"
          echo search_ubuntu
        if keyword is "tutorial"
          echo search_tutorial
        else
          echo search_no_results(inputs[2])
      else echo search

    else if inputs[1] is "pull"
      if keyword = inputs[2]
        if keyword is 'ubuntu'
          result = util_slow_lines(term, pull_ubuntu, "", callback )
        else if keyword is 'learn/tutorial'
          result = util_slow_lines(term, pull_tutorial, "", callback )
        else
          util_slow_lines(term, pull_no_results, keyword)
      else
        echo pull

    else if inputs[1] is "version"
      echo (version)


    else if dockerCommands[inputs[1]]
      echo "#{inputs[1]} is a valid argument, but not implemented"

    # return empty value because otherwise coffeescript will return last var
    return

  ###
    Some default variables / commands

    All items are sorted by alphabet
  ###

  docker_cmd = \
    """
      Usage: docker [OPTIONS] COMMAND [arg...]
      -H="127.0.0.1:4243": Host:port to bind/connect to

      A self-sufficient runtime for linux containers.

      Commands:

    """

  dockerCommands =
    "attach": "    Attach to a running container"
    "build": "     Build a container from a Dockerfile"
    "commit": "    Create a new image from a container's changes"
    "diff": "      Inspect changes on a container's filesystem"
    "export": "    Stream the contents of a container as a tar archive"
    "history": "   Show the history of an image"
    "images": "    List images"
    "import": "    Create a new filesystem image from the contents of a tarball"
    "info": "      Display system-wide information"
    "insert": "    Insert a file in an image"
    "inspect": "   Return low-level information on a container"
    "kill": "      Kill a running container"
    "login": "     Register or Login to the docker registry server"
    "logs": "      Fetch the logs of a container"
    "port": "      Lookup the public-facing port which is NAT-ed to PRIVATE_PORT"
    "ps": "        List containers"
    "pull": "      Pull an image or a repository from the docker registry server"
    "push": "      Push an image or a repository to the docker registry server"
    "restart": "   Restart a running container"
    "rm": "        Remove a container"
    "rmi": "       Remove an image"
    "run": "       Run a command in a new container"
    "search": "    Search for an image in the docker index"
    "start": "     Start a stopped container"
    "stop": "      Stop a running container"
    "tag": "       Tag an image into a repository"
    "version": "   Show the docker version information"
    "wait": "      Block until a container stops, then print its exit code"

  run_switches =
    "-p": ['port']
    "-t": []
    "-i": []
    "-h": ['hostname']

  pull = \
    """
    Usage: docker pull NAME

    Pull an image or a repository from the registry

    -registry="": Registry to download from. Necessary if image is pulled by ID
    -t="": Download tagged image in repository
    """


  pull_no_results = (keyword) ->
    """
    Pulling repository #{keyword} from https://index.docker.io/v1
    2013/06/19 19:27:03 HTTP code: 404
    """

  pull_ubuntu =
    """
    Pulling repository ubuntu from https://index.docker.io/v1
    Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
    Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
    Pulling image 27cf784147099545 () from ubuntu
    """

  pull_tutorial = \
    """
    Pulling repository learn/tutorial from https://index.docker.io/v1
    Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
    Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
    Pulling image 27cf784147099545 () from tutorial
    """

  run_cmd = \
    """
    Usage: docker run [OPTIONS] IMAGE COMMAND [ARG...]

    Run a command in a new container

    -a=map[]: Attach to stdin, stdout or stderr.
    -c=0: CPU shares (relative weight)
    -d=false: Detached mode: leave the container running in the background
    -dns=[]: Set custom dns servers
    -e=[]: Set environment variables
    -h="": Container host name
    -i=false: Keep stdin open even if not attached
    -m=0: Memory limit (in bytes)
    -p=[]: Expose a container's port to the host (use 'docker port' to see the actual mapping)
    -t=false: Allocate a pseudo-tty
    -u="": Username or UID
    -v=map[]: Attach a data volume
    -volumes-from="": Mount volumes from the specified container

    """

  run_learn_tutorial = \
    """
    2013/07/02 02:00:59 Error: No command specified
    """

  run_ubuntu = \
    """
    2013/07/02 02:00:59 Error: No command specified
    """

  run_notfound = (keyword) ->
    """
    Pulling repository #{keyword} from https://index.docker.io/v1
    2013/07/02 02:14:47 Error: No such image: #{keyword}
    """

  search = \
    """

    Usage: docker search NAME

    Search the docker index for images

    """

  search_no_results = (keyword) ->
    """
    Found 0 results matching your query ("#{keyword}")
    NAME                DESCRIPTION
    """

  search_tutorial = \
    """
    Found 1 results matching your query ("tutorial")
    NAME                      DESCRIPTION
    learn/tutorial            An image for the interactive tutorial
    """

  search_ubuntu = \
    """
    Found 22 results matching your query ("ubuntu")
    NAME                DESCRIPTION
    shykes/ubuntu
    base                Another general use Ubuntu base image. Tag...
    ubuntu              General use Ubuntu base image. Tags availa...
    boxcar/raring       Ubuntu Raring 13.04 suitable for testing v...
    dhrp/ubuntu
    creack/ubuntu       Tags:
    12.04-ssh,
    12.10-ssh,
    12.10-ssh-l...
    crohr/ubuntu              Ubuntu base images. Only lucid (10.04) for...
    knewton/ubuntu
    pallet/ubuntu2
    erikh/ubuntu
    samalba/wget              Test container inherited from ubuntu with ...
    creack/ubuntu-12-10-ssh
    knewton/ubuntu-12.04
    tithonium/rvm-ubuntu      The base 'ubuntu' image, with rvm installe...
    dekz/build                13.04 ubuntu with build
    ooyala/test-ubuntu
    ooyala/test-my-ubuntu
    ooyala/test-ubuntu2
    ooyala/test-ubuntu3
    ooyala/test-ubuntu4
    ooyala/test-ubuntu5
    surma/go                  Simple augmentation of the standard Ubuntu...

    """

  version = \
  """
    Docker Emulator version 0.1

    Emulating:
    Client version: 0.4.7
    Server version: 0.4.7
    Go version: go1.1
    """



return this


