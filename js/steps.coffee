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
  return

previous = () ->
  current_question--
  questions[current_question]()
  results.clear()
  return

results = {
  set: (htmlText, intermediate) ->
    if intermediate
      console.debug "intermediate text received"
      $('#results').addClass('intermediate')
      $('#buttonNext').hide()
    else
      $('#buttonNext').show()

    window.setTimeout ( () ->
      $('#resulttext').html(htmlText)
      $('#results').fadeIn()
  #    $('#results').fadeIn('fast')
      $('#buttonNext').removeAttr('disabled')
    ), 300
  #
  #    webterm.echo \
  #    """
  #           _
  #        ,_(')<
  #        \\\___)
  #    """

  clear: ->
    $('#resulttext').html("")
    $('#results').fadeOut('slow')
#    $('#buttonNext').addAttr('disabled')
}

###
  Array of question objects
###

q = []


q.push ({
html: """
      <h2>Getting started</h2>
      <p>There are actually two programs, a Docker daemon, it manages al the containers, and the Docker client.
      The client acts as a remote control on the daemon. On most systems, like in this emulation, both run on the
      same host.</p>
      """
assignment: """
      <h2>Assignment</h2>
      <p>First of all, we want to check if docker is installed correctly and running</p>
      <p><em>docker version</em> will show the versions docker is running. If you get the version numbers, you know
      you are all set.</p>
      """
command_expected: ['docker', 'version']
result: """<p>Well done! Let's move to the next assignment.</p>"""
tip: "try typing `docker version`"
})

q.push ({
html: """
      <h2>Searching for images</h2>
      <p>The easiest way of getting started is to use a container image from someone else. Container images are
      available on the docker index and can be found using <em>docker search</em></p>
      """
assignment: """
      <h2>Assignment</h2>
      <p>Please find for an image called tutorial</p>
      """
command_expected: ['docker', 'search', 'tutorial']
result: """<p>You found it!</p>"""
tip: "the format is `docker search &lt;imagename&gt;`"
})

q.push ({
html: """
      <h2>Downloading container images</h2>
      <p>Container images can be downloaded just as easily, using <em>docker pull.</em></p>
      <p>The name you specify is made up of two parts: the <em>username</em> and the <em>repository name</em>,
      divided by a slash `/`.</p>
      <p>A group of special, trusted images can be retrieved by just their repository name. For example 'ubuntu'.</p>
      """
assignment:
      """
      <h2>Assignment</h2>
      <p>Please download the tutorial image you have just found</p>
      """
command_expected: ['docker', 'pull', 'learn/tutorial']
result: """<p>Cool. Look at the results. You'll see that docker has downloaded a number of different layers</p>"""
tip: """Don't forget to pull the full name of the repository e.g. 'learn/tutorial'"""
})


q.push ({
html: """
      <h2>Hello world from a container</h2>
      <p>You should think about containers as an operating system in a box, except they do not need to be started
      before you can run commands in them.<p>
      <p>Expect that you will be able to run the usual commands such as </p>
      <p>The command `docker run` takes two arguments. An image name, and the command you want to execute within that
      image.</p>
      """
assignment: """
      <h2>Assignment</h2>
      <p>Make our freshly loaded image say "hello world"</p>
      """
command_expected: ["docker", "run", "learn/tutorial", "echo"]
result: """<p>Great! Hellooooo World!</p>"""
intermediateresults: [
  """<p>You seem to be almost there. Did you give the command `echo "hello world"` """,
  """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  ]
tip: """Start by looking at the results of `docker run`, it shows which arguments exist"""
})


q.push ({
html: """
      <h2>Interactive Shell</h2>
      <p>Now, since Docker provides you with the equivalent of a complete operating system you are able to get
      an interactive shell (tty) <em>inside</em> of the container.</p>
      <p>Since we want a prompt in the container, we need to start the shell program in the container. </p>
      <p>You may never have manually started it before, but a popular one typically lives at `/bin/bash`</p>
      """
assignment: """
      <h2>Assignment</h2>
      <p>Your goal is to run the tutorial container you have
      just downloaded and get a shell inside of it.</p>
      <p>The command to run a container is <em>docker run</em></p>
      """
command_expected: ["docker", "run", "-i", "-t", "learn/tutorial", "/bin/bash"]
result: """<p>Great!! Now you have an interactive terminal</p>"""
intermediateresults: [
  """<p>You seem to be almost there. Did you use <em>-i and -t</em>?</p>""",
  """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  """<p>You have the command right, but the shell exits immediately, before printing anything</p>
      <p>You will need to attach your terminal to the containers' terminal.</p>
  """
  ]
tip: """Start by looking at the results of `docker run`, it shows which arguments exist"""
})


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
    $('#tiptexthidden').html(_q.tip)

    window.immediateCallback = (input, stop) ->
      if stop == true # prevent the next event from happening
        doNotExecute = true
      else
        doNotExecute = false

      if doNotExecute != true
        console.log ("callback")
        console.log (input)
        if Object.equal(input, _q.command_expected)
          results.set(_q.result)
        else

  #        console.debug("wrong command received")
      else



      return
    window.intermediateResults = (input) ->
#      alert "itermediate received"
      results.set(_q.intermediateresults[input], intermediate=true)
    return


for question in q
  f = buildfunction(question)
  questions.push(f)


# load the first question, or if the url hash is set, use that

###
  Initialization of program
###

if (window.location.hash)
  try
    currentquestion = window.location.hash.split('#')[1].toNumber()
    questions[currentquestion]()
  catch err
    questions[0]()
else
  questions[0]()

$('#tiptext').click () ->
    tiptext = $('#tiptext')
    if not tiptext.hasClass('showtip')
      tiptext.html($('#tiptexthidden').html())
      tiptext.addClass("showtip").hide().fadeIn()


$('#results').hide()


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
