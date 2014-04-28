define ['models/Question', 'views/main', 'views/terminal', 'parsers/main', 'settings'], ( Question, ApplicationView, TerminalView, Parser, settings ) ->

  class Controller

    questions: null
    lastQuestionNumber: null
    currentQuestionNumber: 0
    currentQuestion: null

    constructor: (@questionList) ->
      log('constructor called')

      @terminalView = new TerminalView(@interpreter)
      @applicationView = new ApplicationView(@terminalView, this)


      # Detect if we start on a different question and start the program there if so.
      if (window.location.hash)
        @currentQuestionNumber = window.location.hash.split('#')[1].toNumber()
        if isNaN(@currentQuestionNumber)
          console.warn({ error: "invalid hash", description: "location hash invalid"})
          @currentQuestionNumber = 0

      for number in [0..(@questionList.length - 1)]
        @applicationView.drawStatusMarker(number)

      @setQuestion(@currentQuestionNumber)

      # if we're debugging we want fullscreen right away
      if settings.DEBUG is true
        @goFullScreen()



    log = (logline) ->
      console.log("Controller: +" + logline)


    setQuestion: (i) ->
      @currentQuestionNumber = i

      @currentQuestion = @questionList[@currentQuestionNumber]
      @currentQuestion.number = @currentQuestionNumber
      @applicationView.render(@currentQuestion)

      # enable history navigation
      history.pushState({}, "", "#" + @currentQuestionNumber);

      @terminalView.focus()

      data = {
        'type': settings.EVENT_TYPES.render
        'question': @currentQuestionNumber
      }
      @logEvent(data)

      # lastly, when all updates are complete, update lastQuestionNumber
      @lastQuestionNumber = @currentQuestionNumber



    goFullScreen: () ->
      data = {
        type: settings.EVENT_TYPES.start
        question: @currentQuestionNumber
      }
      @logEvent(data)

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

      data = {
        question: @currentQuestionNumber
        type: settings.EVENT_TYPES.command
        command: input
      }
      @logEvent(data)


      if inputs[0] is 'hi'
        term.echo 'hi there! What is your name??'
        term.push (input, term) ->
          term.echo input + ' is a pretty name'

      if inputs[0] is 'docker'
        parser = new Parser(inputs, term)
        result = parser.run()

      if inputs[0] is 'r'
        location.reload('forceGet')

      if result and result.answered
        console.debug "answered: " + result.answered

        if @currentQuestion.slug is result.answered
          @applicationView.show_results_dialog(@currentQuestion.result, false)
          return


    ###
      Sending events to the server
    ###

    ## Pull CSRF token from cookie and set it in the request header.
    @getCookie: (name) ->
      cookieValue = null
      if (document.cookie && document.cookie != '')
        cookies = document.cookie.split('; ')
        for cookie in cookies
          $.trim(cookie)
          if cookie.substring(0, name.length + 1) == (name + '=')
            cookieValue = decodeURIComponent(cookie.substring(name.length + 1))
      return cookieValue

    csrfSafeMethod = (method) ->
      regex = /^(GET|HEAD|OPTIONS|TRACE)$/
      return regex.test(method)

    $.ajaxSetup({
      crossDomain: false,
      beforeSend: (xhr, settings) =>
        if !csrfSafeMethod(settings.type)
          xhr.setRequestHeader("X-CSRFToken", Controller.getCookie("csrftoken"))
    })

    logEvent: (data, feedback) ->


      ajax_load = "loading......"
      loadUrl = settings.API_URI
      if not feedback
        callback = (responseText) -> $("#ajax").html(responseText)
      else
        callback = (responseText) ->
          results.set("Thank you for your feedback! We appreciate it!", true)
          $('#feedbackInput').val("")
          $("#ajax").html(responseText)

      if not data then data = {type: EVENT_TYPES.none}
      if not data.question?
        data.question = @currentQuestionNumber

      $("#ajax").html(ajax_load);

      if settings.LOG_EVENTS_TO_SERVER
        $.post(loadUrl, data, callback, "html")
      else
        console.debug {loadUrl: loadUrl, question: data.question, type: data.type, data: data}


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