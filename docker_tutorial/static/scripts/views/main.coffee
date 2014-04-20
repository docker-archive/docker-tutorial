define [], () ->

  class View


    @current_question: 0

    constructor: (settings, @terminalView, @controller) ->
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
        _this.controller.next()
        return

      ## Stop mousewheel on left side, and manually move it.
      $('#leftside').bind('mousewheel',
        (event, delta, deltaX, deltaY) ->
          this.scrollTop += deltaY * -30
          event.preventDefault()
        )

      ## submit feedback
      $('#feedbackSubmit').click ->
        feedback = $('#feedbackInput').val()
        data = { type: EVENT_TYPES.feedback, feedback: feedback}
        logEvent(data, feedback=true)

      ## click on tips
      $('#command').click () ->
        if not $('#commandHiddenText').hasClass('hidden')
          $('#commandHiddenText').addClass("hidden").hide()
          $('#commandShownText').hide().removeClass("hidden").fadeIn()

        data = { type: EVENT_TYPES.peek }
        logEvent(data)




    log = (logline) ->
      console.log("View: " + logline)


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
      Navigation amongst the questions
    ###

    next: (which) =>
      # before increment clear style from previous question progress indicator
      $('#marker-' + current_question).addClass("complete").removeClass("active")

      if not which and which != 0
        current_question++
      else
        current_question = which

#      @render(current_question)

#      @questions[current_question]()
#      results.clear()
#      @webterm.focus()

      if not $('#commandShownText').hasClass('hidden')
        $('#commandShownText').addClass("hidden")
        $('#commandHiddenText').removeClass("hidden").show()

      # enable history navigation
      history.pushState({}, "", "#" + current_question);
#      data = { 'type': EVENT_TYPES.next }
#      logEvent(data)

      # change the progress indicator
      $('#marker-' + current_question).removeClass("complete").addClass("active")

      $('#question-number').find('text').get(0).textContent = current_question

      # show in the case they were hidden by the complete step.
      $('#instructions .assignment').show()
      $('#tips, #command').show()


      return

    previous = () ->
      current_question--
      questions[current_question]()
      results.clear()
      @webterm.focus()
      return




    ###
      Transform question objects into functions
    ###

    render: (q) =>
      _q = q

      $('#results').hide()

      console.debug("render question called")

      $('#instructions').hide().fadeIn()
      $('#instructions .text').html(_q.html)
      $('#instructions .assignment').html(_q.assignment)
      $('#tipShownText').html(_q.tip)


      window.intermediateResults = (input) ->
        if _q.intermediateresults
          results.set(_q.intermediateresults[input](), intermediate=true)



      # callback with named question
      window.questionAnswered = (input) ->
        results.set(_q.result)
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

  return View



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