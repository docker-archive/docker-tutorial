###
  Please note the javascript is being fully generated from coffeescript.
  So make your changes in the .coffee file.
  Thatcher Peskens
         _
      ,_(')<
      \___)

###


root = exports ? this

@app = root.app || {}

require.config({
  baseUrl: '/static/js',
  paths: {
        lib: '/static/lib/js'
    }

});

require ['models/question',
         'data/questionlist',
         'controller',
         'views/main',
         'views/terminal',
         'parsers/main',
         'lib/domReady'], \
            (Question,
            questionList,
            Controller,
            View,
            TerminalView,
            Parser,
            domReady) ->

  settings = {
      "debug": true
  }

  class App

    constructor: () ->
      log("constructor called")
      @Question = new Question()
#      @view = new View(settings)
      @controller = new Controller(@questionlist = questionList, @settings = settings )
      @Parser = Parser

      # if we're debuggin we want fullscreen
      if settings.debug is true
        @controller.goFullScreen()

    # log function
    log = (logline) ->
      console.log("App: " + logline)


  # connect app to the global namespace
  @app = new App()
