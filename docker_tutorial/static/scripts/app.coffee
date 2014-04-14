root = exports ? this

@app = root.app || {}

require.config({
  baseUrl: '/static/js',

});

require ['models/question',
         'data/questionlist',
         'controller',
         'views/main',
         'views/terminal',
         'parsers/main'], \
            (Question,
            questionList,
            Controller,
            View,
            TerminalView,
            Parser) ->

  class App
    constructor: () ->
      log("constructor called")
      @Question = new Question()
      @view = new View()
      @controller = new Controller(view = @view, model = @model, @questionlist = questionList)

      @Parser = Parser

    log = (logline) ->
      console.log("App: " + logline)


  # connect app to the global namespace
  @app = new App()
