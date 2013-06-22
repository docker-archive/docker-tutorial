###
  This is the main script file. It can attach to the terminal
###


###
  Register the things
###

@webterm = $('#terminal').terminal(interpreter, basesettings)

$('#buttonNext').click ->
  next()
  $('#results').hide()

$('#buttonPrevious').click ->
  previous()
  $('#results').hide()



###
  Start with the questions
###

# the index arr
questions = []

current_question = 0
next = () ->
  current_question++
  questions[current_question]()
  results.clear()

previous = () ->
  current_question--
  questions[current_question]()
  results.clear()



results = {
  set: (htmlText) ->
    $('#results').html(htmlText)
  clear: ->
    $('#results').html("")
}

###
  Array of question objects
###

q = []

q.push ({
  html: """
  <h1>Welcome</h1>

  Please type docker search ubuntu

  """
  command_expected: ['docker']
  result: "yeey! hurray, woohooo, you did it, amazing, you are awesome, you completed the first assignment."
  tip: "try typing `docker version"
})

q.push ({
html: """
      <h1>Check if Docker is running</h1>

      `docker version` will show the versions docker is running. If either are not present this will show a warning

      <h4>background:</h4>
      There are actually two programs, a Docker daemon, it actually manages al lthe containers, and the Docker client. It acts as a remote control. On most systems, like ours, both run on the same host.
      """
command_expected: ['docker', 'version']
result: "Well done."
tip: "try typing `docker version"
})


###
  Transform question objects into functions
###

buildfunction = (q) ->
  _q = q
  return ->
    console.debug("function called")
    $('#instructions .text').html(_q.html)
    window.immediateCallback = (input) ->
      console.log (input)
      if Object.equal(input, _q.command_expected)
        $('#results').show()
        $('#results .text').html(_q.result)
        $('#buttonNext').removeAttr('disabled')
      else
        $('#results.text').html(_q.partial_results)
      return
    return


for question in q
  f = buildfunction(question)
  questions.push(f)


# load the first question
questions[0]()



###
  Make the resizing possible
###

$('#fullSizeOpen').click ->
  console.debug("going to fullsize mode")

  $('#overlay').addClass('fullsize')
  $('#main').addClass('fullsize')
  $('#tutorialTop').addClass('fullsize')

  webterm.resize()

$('#fullSizeClose').click ->

  leaveFullSizeMode()


leaveFullSizeMode = () ->
  console.debug "leaving full-size mode"
  $('#overlay').removeClass('fullsize')
  $('#main').removeClass('fullsize')
  $('#tutorialTop').removeClass('fullsize')
  webterm.resize()
