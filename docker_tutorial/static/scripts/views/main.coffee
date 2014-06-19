define ['settings'], (settings) ->

  class ApplicationView

    constructor: (@terminalView, @controller) ->
      log("constructor called")
      _this = this

      ###
        Register event handlers
      ###

      ## fullsize
      $('#fullSizeOpen').click =>
        @controller.goFullScreen()
        return

      ## leave fullsize
      $('#fullSizeClose').click =>
        @controller.leaveFullScreen()
        return

      ## click next button
      $('#buttonNext').click ->
        this.setAttribute('disabled', 'disabled')
        _this.controller.setQuestion(_this.controller.currentQuestionNumber + 1)
        return

      ## Stop mousewheel on left side, and manually move it.
      $('#leftside').bind('mousewheel',
        (event, delta, deltaX, deltaY) ->
          this.scrollTop += deltaY * -30
          event.preventDefault()
        )

      ## submit feedback
      $('#feedbackSubmit').click =>
        feedback = $('#feedbackInput').val()
        data = { type: settings.EVENT_TYPES.feedback, feedback: feedback}
        @controller.logEvent(data, feedback=true)

      ## click on tips
      $('#command').click () =>
        if not $('#commandHiddenText').hasClass('hidden')
          $('#commandHiddenText').addClass("hidden").hide()
          $('#commandShownText').hide().removeClass("hidden").fadeIn()

        data = { type: settings.EVENT_TYPES.peek }
        @controller.logEvent(data)
        return




    log = (logline) ->
      console.log("View: " + logline)

    ###
      Manipulate the layout
    ###

    goFullScreen: () ->
      console.debug("going to fullsize mode")
      $('.togglesize').removeClass('startsize').addClass('fullsize')

      $('.hide-when-small').css({ display: 'inherit' })
      $('.hide-when-full').css({ display: 'none' })

#      @next(0)
#      @render(0)

#      webterm.resize()

      # send the next event after a short timeout, so it doesn't come at the same time as the next() event
      # in the beginning. Othewise two sessions will appear to have been started.
      # This will make the order to appear wrong, but that's not much of an issue.

#      setTimeout( () ->
#        logEvent( { type: EVENT_TYPES.start } )
#      , 3000)


    leaveFullScreen: () ->
      console.debug "leaving full-size mode"
      $('.togglesize').removeClass('fullsize').addClass('startsize')
      $('.hide-when-small').css({ display: 'none' })
      $('.hide-when-full').css({ display: 'inherit' })


    ###
      Functions for DOM manipulation
    ###

    render: (q) =>
      _q = q

      $('#results').hide()

      console.debug("render question called")

      $('#instructions').hide().fadeIn()
      $('#instructions .title').html(_q.title)
      $('#instructions .text').html(_q.html)
      $('#assignment .assignment').html(_q.assignment)
      $('#tipShownText').html(_q.tip)

      if _q.command_show
        $('#commandShownText').html(_q.command_show.join(' '))
      else
        $('#commandShownText').html(_q.command_expected.join(' '))


      # update markers
#      $('#marker-' + @controller.lastQuestionNumber).addClass("complete").removeClass("active")
#      $('#marker-' + @controller.currentQuestionNumber).addClass("active")

      $('#stepselector-' + @controller.lastQuestionNumber).addClass("complete").removeClass("active")
      $('#stepselector-' + @controller.currentQuestionNumber).addClass("active")

      $('#stepselector-button .current').text(@controller.currentQuestionNumber)
#
#      window.intermediateResults = (input) ->
#        if _q.intermediateresults
#          results.set(_q.intermediateresults[input](), intermediate=true)
#
#      # callback with named question
#      window.questionAnswered = (input) ->
#        results.set(_q.result)

      $('#commandShownText').addClass("hidden")
      $('#commandHiddenText').removeClass("hidden").show()

      return


    show_results_dialog: (htmlText, intermediate) =>
      if intermediate
        console.debug "intermediate text received"
        $('#results').addClass('intermediate')
        $('#buttonNext').hide()
      else
        $('#buttonNext').show()

      setTimeout( ( =>
        # disable the webterm so it doesn't keep focus
        @terminalView.disable()
        # focus on the button
        $('#buttonNext').focus()
      ), 1000)

      window.setTimeout ( () =>
        $('#resulttext').html(htmlText)
        $('#results').fadeIn()
        $('#buttonNext').removeAttr('disabled')
      ), 300

    clear_results_dialog: () ->
      $('#resulttext').html("")
      $('#results').fadeOut('slow')


    # Question navigation

    statusMarker: $('#progress-marker-0')
    progressIndicator: $('#progress-indicator')

    stepSelector: $('#stepselector-0')
    stepDropdown: $('#stepDropdown')


    drawSelectionDropdown: (questionList) =>

      _controller = @controller

      i = 0
      for question in questionList
        question.number = i
        i++

      setClick = (marker, question) ->
        marker.click( ->
          _controller.setQuestion(question.number)
        )

      for question in questionList

        if question.number == 0
          marker = @stepSelector
        else
          marker = @stepSelector.clone()
          marker.appendTo(@stepDropdown)

        marker.attr("id", "stepselector-" + question.number)
        marker.find('a').get(0).href = "#" + question.number
        marker.find('a').get(0).textContent = question.number + " " + question.title

        # Set click out of function to create closure
        setClick(marker, question)


      $('#stepselector-button .total').text(questionList.length)


  return ApplicationView



#root.app = root.app || {}
#root.app.ApplicationView = ApplicationView


#do @ApplicationView = ->

  # Full size / exit full size
  # -> action on view only
  # -> trigger notify action on controller

  # Submit feedback
  # -> action on view
  # -> trigger feedback on controller
  # <- show results of feedback

  # Click next
  # -> trigger next question on controller

  # Click question (jump)
  # -> trigger next question on controller


  # Show results of feedback

  # Change out question HTML

  # Change view size



#  return ""