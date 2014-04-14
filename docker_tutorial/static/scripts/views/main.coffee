define [], () ->

  class View


    @current_question: 0

    constructor: ->
      log("constructor called")


      ###
        Register event handlers
      ###

      ## fullsize
      $('#fullSizeOpen').click =>
        @goFullScreen()
        return

      ## leave fullsize
      $('#fullSizeClose').click =>
        @leaveFullSizeMode()
        return

    log = (logline) ->
      console.log("View: " + logline)


    goFullScreen: () ->
      console.debug("going to fullsize mode")
      $('.togglesize').removeClass('startsize').addClass('fullsize')

      $('.hide-when-small').css({ display: 'inherit' })
      $('.hide-when-full').css({ display: 'none' })

#      @next(0)
      @render(0)

      webterm.resize()

      # send the next event after a short timeout, so it doesn't come at the same time as the next() event
      # in the beginning. Othewise two sessions will appear to have been started.
      # This will make the order to appear wrong, but that's not much of an issue.

#      setTimeout( () ->
#        logEvent( { type: EVENT_TYPES.start } )
#      , 3000)


    leaveFullSizeMode: () ->
      console.debug "leaving full-size mode"
      $('.togglesize').removeClass('fullsize').addClass('startsize')
      $('.hide-when-small').css({ display: 'none' })
      $('.hide-when-full').css({ display: 'inherit' })
      webterm.resize()

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

    render: (q) ->
      _q = q

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