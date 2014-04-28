define ['parsers/utils'], (utils) ->


  class DockerPull

    args: null

    constructor: (@input, @term) ->

      @args = {}

      SWITCHES = [ ]

      @optparser = new optparse.OptionParser(SWITCHES)
      @optparser.banner =
      """

      Usage: docker pull NAME

      Pull an image or a repository from the registry
      """
      @optparser.options_title = null

      # prep the parser
      @optparser.on(2, (value) =>
        @args.image = value
        return {}
      )

      # parse it
      @optparser.parse(@input)

    run: () ->

      if not @args.image?
        @term.echo @optparser.toString()
        return ""

      if @args.image in ['ubuntu',]

        one = => @term.echo @pull_ubuntu_1
        two = => @term.echo @pull_ubuntu_2
        three = => @term.echo @pull_ubuntu_3

        setTimeout one, 200
        setTimeout two, 1000
        setTimeout three, 2000

        return {}

      if @args.image is 'learn/tutorial'
        one = => @term.echo @pull_ubuntu_1
        two = => @term.echo @pull_ubuntu_2
        three = => @term.echo @pull_ubuntu_3

        done = => questionAnswered('docker-pull')

        setTimeout one,   200
        setTimeout two,   1000
        setTimeout three, 2000
        setTimeout done,  2400

        return {'answered': 'docker-pull'}

      if @args.image?

        one = => @term.echo @pull_no_results(@args.image)
        setTimeout one, 600
        return {}


    ###
      Collection of Mock PULL and PUSH results
    ###

    pull_no_results: (keyword) ->
      """
      Pulling repository #{keyword}
      #{utils.timestamp()} HTTP code: 404
      """

    pull_ubuntu_1: -> """
      Pulling repository learn/tutorial
      58394af37342: Downloading [=============>                                     ] 30.65 MB/117.4 MB 18s
      """

    pull_ubuntu_2: -> """
      58394af37342: Downloading [===================================>               ] 90.45 MB/117.4 MB 5s
      """

    pull_ubuntu_3: -> """
      58394af37342: Download complete
      9cd978db300e: Download complete
      6170bb7b0ad1: Download complete
    """

    pull_tutorial: \
      """
      Pulling repository learn/tutorial from https://index.docker.io/v1
      Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
      Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
      Pulling image 27cf784147099545 () from tutorial
      """



  return DockerPull
