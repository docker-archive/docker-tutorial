###
  This is the main script file. It can attach to the terminal
###


###
  Register the things
###

@webterm = $('#terminal').terminal(interpreter, basesettings)

$('#buttonNext').click ->
  next()

$('#buttonPrevious').click ->
  previous()



###
  Start with the questions
###

# the index arr
questions = []

question = 0
next = () ->
  question++
  questions[question]()
  results.clear()

previous = () ->
  question--
  questions[question]()
  results.clear()



results = {
  set: (htmlText) ->
    $('#results').html(htmlText)
  clear: ->
    $('#results').html("")
}

questions.push(  ->
  $('#instructions').html(
    """
    <h1>one</h1>
    Welcome

    Please type docker search ubuntu

    """
  )
  window.immediateCallback = (input) ->
    console.log(input)
    if Object.equal(input, ['docker', 'search', 'ubuntu'])
      results.set """
        yeey! hurray, woohooo, you did it, amazing, you are awesome, you completed the first assignment.
        """
    else
      results.set """
        That was not the right command.
        """
    return
  )


questions.push( ->
  $('#instructions').html(
    """
    <h1>two</h1>
    <p>Great. Now you know how to find images, lets download them. The command to use is "pull".</p>
    <p>Go ahead and pull the tutorial image</p>
    """
  )
  window.finishedCallback = (input) ->
    console.log(input)
    if Object.equal(input, ['docker', 'pull', 'ubuntu'])
      $('#results').html(
        """
        yeey! hurray, woohooo, you did it, amazing, you are awesome, you completed the second assignment.
        """
      )
    return
  )


questions[0]()



###
  Make the resizing possible
###

$('#fullSizeOpen').click ->
  console.debug("going to fullsize mode")

  $('#overlay').addClass('fullsize')
  $('#main').addClass('fullsize')
  $('#tutorialTop').addClass('fullsize')


$('#fullSizeClose').click ->

  leaveFullSizeMode()


leaveFullSizeMode = () ->
  console.debug "leaving full-size mode"
  $('#overlay').removeClass('fullsize')
  $('#main').removeClass('fullsize')
  $('#tutorialTop').removeClass('fullsize')
