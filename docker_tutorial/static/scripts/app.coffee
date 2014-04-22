###
  Please note the javascript is being fully generated from coffeescript.
  So make your changes in the .coffee file.
  Thatcher Peskens
         _
      ,_(')<
      \___)

###

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
         'lib/domReady',
         'settings'], \
            (Question,
            questionList,
            Controller,
            View,
            TerminalView,
            Parser,
            domReady,
            settings) ->

  class App

    constructor: () ->
      log("constructor called")
      @Question = new Question()
#      @view = new View(settings)
      @controller = new Controller(@questionlist = questionList)
      @Parser = Parser


    # log function
    log = (logline) ->
      console.log("App: " + logline)


  # connect app to the global namespace
  @app = new App()
