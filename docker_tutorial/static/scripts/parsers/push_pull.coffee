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