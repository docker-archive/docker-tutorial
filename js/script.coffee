###
  Please note the javascript is being fully generated from coffeescript. So make your changes here.
  Thatcher Peskens
###


$ ->

  id = 1

  basesettings = {
    prompt: '>>>>> $ ',
    greetings: "Welcome to the interactive Docker tutorial. Enter 'docker' to begin",
  }

  interpreter = (command, term) ->
    if command is 'hi'
      term.echo 'hi there! What would you like to do today?'
      term.push (command, term) ->
        term.echo command + ' is a pretty name'

    if command is "help"
      term.echo 'printing help'
      term.echo '[[b]printing help]'

    if command is "docker"
      for dockerCommand, description of dockerCommands
        term.echo ("[[b]" + dockerCommand + "] " + description + "")


  $('body').terminal( interpreter, basesettings )


#  $('body').terminal( (command, term) ->
#    alert (command) )


  dockerCommands =
    "attach": "Attach to a running container"
    "build": "Build a container from a Dockerfile"
    "commit": "Create a new image from a container's changes"
    "diff": "Inspect changes on a container's filesystem"
    "export": "Stream the contents of a container as a tar archive"
    "history": "Show the history of an image"
    "images": "List images"
    "import": "Create a new filesystem image from the contents of a tarball"
    "info": "Display system-wide information"
    "insert": "Insert a file in an image"
    "inspect": "Return low-level information on a container"
    "kill": "Kill a running container"
    "login": "Register or Login to the docker registry server"
    "logs": "Fetch the logs of a container"
    "port": "Lookup the public-facing port which is NAT-ed to PRIVATE_PORT"
    "ps": "List containers"
    "pull": "Pull an image or a repository from the docker registry server"
    "push": "Push an image or a repository to the docker registry server"
    "restart": "Restart a running container"
    "rm": "Remove a container"
    "rmi": "Remove an image"
    "run": "Run a command in a new container"
    "search": "Search for an image in the docker index"
    "start": "Start a stopped container"
    "stop": "Stop a running container"
    "tag": "Tag an image into a repository"
    "version": "Show the docker version information"
    "wait": "Block until a container stops, then print its exit code"
