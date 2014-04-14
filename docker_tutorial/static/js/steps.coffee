###
  This is the main script file. It can attach to the terminal
###


app = Application.get()


###
  Array of question objects
###

q = app.questions

# the index arr
questions = []


###
  Register the terminal
###

@webterm = $('#terminal').terminal(interpreter, basesettings)


EVENT_TYPES =
  none: "none"
  start: "start"
  command: "command"
  next: "next"
  peek: "peek"
  feedback: "feedback"
  complete: "complete"



###
  Sending events to the server
###

logEvent = (data, feedback) ->

  if LOG_EVENTS?
    ajax_load = "loading......"
    loadUrl = "/tutorial/api/"
    if not feedback
      callback = (responseText) -> $("#ajax").html(responseText)
    else
      callback = (responseText) ->
        results.set("Thank you for your feedback! We appreciate it!", true)
        $('#feedbackInput').val("")
        $("#ajax").html(responseText)

    if not data then data = {type: EVENT_TYPES.none}
    data.question = current_question


    $("#ajax").html(ajax_load);
    $.post(loadUrl, data, callback, "html")



###
  Event handlers
###


## next
$('#buttonNext').click (e) ->

  # disable the button to prevent spacebar to hit it when typing in the terminal
  this.setAttribute('disabled','disabled')
  console.log(e)
  next()

$('#buttonFinish').click ->
  window.open(app.COMPLETE_URL)

## previous
$('#buttonPrevious').click ->
  previous()
  $('#results').hide()

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

## fullsize
$('#fullSizeOpen').click ->
  goFullScreen()

@goFullScreen = () ->
  console.debug("going to fullsize mode")
  $('.togglesize').removeClass('startsize').addClass('fullsize')

  $('.hide-when-small').css({ display: 'inherit' })
  $('.hide-when-full').css({ display: 'none' })

  next(0)

  webterm.resize()

  # send the next event after a short timeout, so it doesn't come at the same time as the next() event
  # in the beginning. Othewise two sessions will appear to have been started.
  # This will make the order to appear wrong, but that's not much of an issue.

  setTimeout( () ->
    logEvent( { type: EVENT_TYPES.start } )
  , 3000)


## leave fullsize
$('#fullSizeClose').click ->
  leaveFullSizeMode()

@leaveFullSizeMode = () ->
  console.debug "leaving full-size mode"

  $('.togglesize').removeClass('fullsize').addClass('startsize')

  $('.hide-when-small').css({ display: 'none' })
  $('.hide-when-full').css({ display: 'inherit' })

  webterm.resize()

## click on tips
$('#command').click () ->
  if not $('#commandHiddenText').hasClass('hidden')
    $('#commandHiddenText').addClass("hidden").hide()
    $('#commandShownText').hide().removeClass("hidden").fadeIn()

  data = { type: EVENT_TYPES.peek }
  logEvent(data)



###
  Navigation amongst the questions
###


current_question = 0
next = (which) ->
  # before increment clear style from previous question progress indicator
  $('#marker-' + current_question).addClass("complete").removeClass("active")

  if not which and which != 0
    current_question++
  else
    current_question = which

  questions[current_question]()
  results.clear()
  @webterm.focus()

  if not $('#commandShownText').hasClass('hidden')
    $('#commandShownText').addClass("hidden")
    $('#commandHiddenText').removeClass("hidden").show()

  # enable history navigation
  history.pushState({}, "", "#" + current_question);
  data = { 'type': EVENT_TYPES.next }
  logEvent(data)

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



results = {
  set: (htmlText, intermediate) ->

    if intermediate
      console.debug "intermediate text received"
      $('#results').addClass('intermediate')
      $('#buttonNext').hide()
    else
      $('#buttonNext').show()

    setTimeout( ( ->
      # disable the webterm so it doesn't keep focus
      @webterm.disable()
      # focus on the button
      $('#buttonNext').focus()
    ), 1000)

    window.setTimeout ( () ->
      $('#resulttext').html(htmlText)
      $('#results').fadeIn()
      $('#buttonNext').removeAttr('disabled')
    ), 300

  clear: ->
    $('#resulttext').html("")
    $('#results').fadeOut('slow')
#    $('#buttonNext').addAttr('disabled')
}



###
  Transform question objects into functions
###

buildfunction = (q) ->
  _q = q
  return ->
    console.debug("function called")

    $('#instructions').hide().fadeIn()
    $('#instructions .text').html(_q.html)
    $('#instructions .assignment').html(_q.assignment)
    $('#tipShownText').html(_q.tip)
    if _q.command_show
      $('#commandShownText').html(_q.command_show.join(' '))
    else
      $('#commandShownText').html(_q.command_expected.join(' '))

#    if _q.currentDockerPs?
#      window.currentDockerPs = _q.currentDockerPs
#    else
#      window.currentDockerPs = staticDockerPs

    if _q.finishedCallback?
      window.finishedCallback = q.finishedCallback
    else
      window.finishedCallback = () -> return ""

#    window.immediateCallback = (input, stop) ->
#      if stop == true # prevent the next event from happening
#        doNotExecute = true
#      else
#        doNotExecute = false
#
#      if doNotExecute != true
#        console.log (input)
#
#        data = { 'type': EVENT_TYPES.command, 'command': input.join(' '), 'result': 'fail' }
#
#        if input.containsAllOfTheseParts(_q.command_expected)
#          data.result = 'success'
#
#          setTimeout( ( ->
#            @webterm.disable()
#            $('#buttonNext').focus()
#          ), 1000)
#
#          results.set(_q.result)
#          console.debug "contains match"
#        else
#          console.debug("wrong command received")
#
#        # call function to submit data
#        logEvent(data)
#      return

    window.intermediateResults = (input) ->
      if _q.intermediateresults
        results.set(_q.intermediateresults[input](), intermediate=true)



    # callback with named question
    window.questionAnswered = (input) ->
      results.set(_q.result)
    return



statusMarker = $('#progress-marker-0')
progressIndicator = $('#progress-indicator')#

drawStatusMarker = (i) ->
  if i == 0
    marker = statusMarker
  else
    marker = statusMarker.clone()
    marker.appendTo(progressIndicator)

  marker.attr("id", "marker-" + i)
  marker.find('text').get(0).textContent = i
  marker.click( -> next(i) )


questionNumber = 0
for question in q
  f = buildfunction(question)
  questions.push(f)
  drawStatusMarker(questionNumber)
  questionNumber++


###
  Initialization of program
###

#load the first question, or if the url hash is set, use that
if (window.location.hash)
  try
    currentquestion = window.location.hash.split('#')[1].toNumber()
#    questions[currentquestion]()
#    current_question = currentquestion
    next(currentquestion)

  catch err
    questions[0]()
else
  questions[0]()

$('#results').hide()


###
  Pull CSRF token from cookie and set it in the request header.
###

getCookie = (name) ->
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
  beforeSend: (xhr, settings) ->
    if !csrfSafeMethod(settings.type)
      xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken"))
})
