define ['models/Question'], ( Question ) ->

  class Controller

    questions: []

    constructor: (@view, @model, @questionList) ->
      log('constructor called')
#      @initializeQuestions()

#      @webterm = $('#terminal').terminal(interpreter, basesettings)



      @view.render(questionList[0])


    log = (logline) ->
      console.log("Controller: +" + logline)


#    initializeQuestions: () ->
#      if @questions.length < 2
#        question = new Question()
#
#        @questions.push 'one'
#
#      return @questions



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