###
  Function to parse docker 'push' specifically, and return the expected output
###

@docker_push = (ARGS) ->

  SWITCHES = [  ]

  parser = new optparse.OptionParser(SWITCHES)
  parser.banner =
  """
  Usage: docker push NAME

  Push an image or a repository to the registry
  """
  parser.options_title = ""

  c = {}

  # prep the parser
  parser.on(2, (value) ->
    ### Get the image name ###
    parserterm.echo "parser.on(2, (#{value}) ->"
    c.image = value
  )

  # parse it
  parser.parse(ARGS)

  if not c.image?
    return parser.toString()

@docker_pull = (ARGS) ->

  SWITCHES = [
    ['-t', '--tag', 'Download tagged image in repository']
  ]

  parser = new optparse.OptionParser(SWITCHES)
  parser.banner =
  """
  Usage: docker pull NAME

  Pull an image or a repository from the registry
  """

  c = {}
  # prep the parser
  parser.on(2, (value) ->
    c.image = value
  )

  # parse it
  parser.parse(ARGS)

  if not c.image?
    return parser.toString()

  if c.image in ['ubuntu',]

    one = -> parserterm.echo pull_ubuntu_1
    two = -> parserterm.echo pull_ubuntu_2
    three = -> parserterm.echo pull_ubuntu_3

    setTimeout one, 1000
    setTimeout two, 2000
    setTimeout three, 3000

    return ""

  if c.image is 'learn/tutorial'
    one = -> parserterm.echo pull_ubuntu_1
    two = -> parserterm.echo pull_ubuntu_2
    three = -> parserterm.echo pull_ubuntu_3

    done = -> questionAnswered('docker-pull')

    setTimeout one, 1000
    setTimeout two, 2000
    setTimeout three, 3000
    setTimeout done, 3400

    return ""



###
  Collection of Mock PULL and PUSH results
###



pull_no_results = (keyword) ->
  """
  Pulling repository #{keyword}
  #{utils.timestamp()} HTTP code: 404
  """

pull_ubuntu_1 = -> """
  58394af37342: Downloading [=============>                                     ] 30.65 MB/117.4 MB 18s
  """

pull_ubuntu_2 = -> """
  58394af37342: Downloading [===================================>               ] 90.45 MB/117.4 MB 5s
  """

pull_ubuntu_3 = -> """
  58394af37342: Download complete
  9cd978db300e: Download complete
  6170bb7b0ad1: Download complete
"""


pull_tutorial = \
  """
  Pulling repository learn/tutorial from https://index.docker.io/v1
  Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
  Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
  Pulling image 27cf784147099545 () from tutorial
  """

push_container_learn_ping = \
  """
  The push refers to a repository [learn/ping] (len: 1)
  Processing checksums
  Sending image list
  Pushing repository learn/ping (1 tags)
  Pushing 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c
  Image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c already pushed, skipping
  Pushing tags for rev [8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c] on {https://registry-1.docker.io/v1/repositories/learn/ping/tags/latest}
  Pushing a1dbb48ce764c6651f5af98b46ed052a5f751233d731b645a6c57f91a4cb7158
  Pushing  11.5 MB/11.5 MB (100%)
  Pushing tags for rev [a1dbb48ce764c6651f5af98b46ed052a5f751233d731b645a6c57f91a4cb7158] on {https://registry-1.docker.io/v1/repositories/learn/ping/tags/latest}
  """

push_wrong_name = \
"""
The push refers to a repository [dhrp/fail] (len: 0)
"""