define ['models/Question', 'views/main', 'views/terminal', 'parsers/main'], ( Question, ApplicationView, TerminalView, Parser ) ->

  class Controller

    questions: []
    currentQuestionNumber: 0
    currentQuestion: {}

    constructor: (@questionList, @settings) ->
      log('constructor called')
#      @initializeQuestions()

#      @webterm = $('#terminal').terminal(interpreter, basesettings)
      @terminalView = new TerminalView(@interpreter)
      @applicationView = new ApplicationView(@settings, @terminalView, this)


      console.log(@questionList)
      @next()

    log = (logline) ->
      console.log("Controller: +" + logline)


    next: () ->

      @currentQuestion = @questionList[@currentQuestionNumber]
      @applicationView.render(@currentQuestion)

      @currentQuestionNumber++

      @terminalView.focus()

    goFullScreen: () ->
      @applicationView.goFullScreen()
      @terminalView.resize()
      return

    leaveFullScreen: () ->
      @applicationView.leaveFullScreen()
      @terminalView.resize()
      return


    ###
    The 'main' interpreter
    ###
    interpreter: (input, term) =>

      inputs = input.split(" ")
      command = inputs[0]

      if inputs[0] is 'hi'
        term.echo 'hi there! What is your name??'
        term.push (input, term) ->
          term.echo input + ' is a pretty name'

      if inputs[0] is 'docker'
        parser = new Parser(inputs, term)
        result = parser.run()


      if result and result.answered
        console.debug "answered: " + result.answered

        if @currentQuestion.slug is result.answered
          @applicationView.show_results_dialog(@currentQuestion.result, false)
          return



  return Controller


# @questionAnswered = (input) ->
#      results.set(_q.result)



  # next question
  # -> trigger view updates
  # -> log data

  # terminal input
  # -> send data to server
  # -> parse data
  #   -> create new parser
  #   -> tell it to parse stuff
  #   -> trigger feedback
  #   -> send results to terminal

  # questionAnswered
  # -> check if current question


  # submit feedback
  # -> send data to server

  # log event
  # -> send data to server





#  return ""