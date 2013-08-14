###
  This is the main script file. It can attach to the terminal
###

COMPLETE_URL = "/whats-next/"


###
  Array of question objects
###

staticDockerPs = """
    ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
    """


q = []
q.push ({
html: """
      <h3>Getting started</h3>
      <p>There are actually two programs: The Docker daemon, which is a server process and which manages all the
      containers, and the Docker client, which acts as a remote control on the daemon. On most systems, like in this
      emulator, both execute on the same host.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Check which Docker versions are running</p>
      <p>This will help you verify the daemon is running and you can connect to it. If you see which version is running
      you know you are all set.</p>
      """
tip: "<p>Try typing <code>docker</code> to see the full list of accepted arguments</p>
      <p>This emulator provides only a limited set of shell and Docker commands, so some commands may not work as expected</p>"
command_expected: ['docker', 'version']
result: """<p>Well done! Let's move to the next assignment.</p>"""
})

q.push ({
html: """
      <h3>Searching for images</h3>
      <p>The easiest way to get started is to use a container image from someone else. Container images are
      available on the Docker index, a central place to store images. You can find them online at
      <a href="#1" onClick="window.open('http://index.docker.io','Docker Index','width=1000,height=900,left=50,top=50,menubar=0')";>index.docker.io</a>
      and by using the commandline</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use the commandline to search for an image called tutorial</p>
      """
command_expected: ['docker', 'search', 'tutorial']
result: """<p>You found it!</p>"""
tip: "the format is <code>docker search &lt;string&gt;</code>"
})

q.push ({
html: """
      <h3>Downloading container images</h3>
      <p>Container images can be downloaded just as easily, using <code>docker pull</code>.</p>
      <p>For images from the central index, the name you specify is constructed as &lt;username&gt;/&lt;repository&gt;</p>
      <p>A group of special, trusted images such as the ubuntu base image can be retrieved by just their name &lt;repository&gt;.</p>
      """
assignment:
      """
      <h3>Assignment</h3>
      <p>Please download the tutorial image you have just found</p>
      """
command_expected: ['docker', 'pull', 'learn/tutorial']
result: """<p>Cool. Look at the results. You'll see that Docker has downloaded a number of layers. In Docker all images (except the base image) are made up of several cumulative layers.</p>"""
tip: """<p>Don't forget to pull the full name of the repository e.g. 'learn/tutorial'</p>
     <p>Look under 'show expected command if you're stuck.</p>
     """
})


q.push ({
html: """
      <h3>Hello world from a container</h3>
      <p>You can think about containers as a process in a box. The box contains everything the process might need, so
      it has the filesystem, system libraries, shell and such, but by default none of it is started or run.<p>
      <p>You 'start' a container <em>by</em> running a process in it. This process is the only process run, so when
      it completes the container is fully stopped.
      """
assignment: """
      <h3>Assignment</h3>
      <p>Make our freshly loaded container image output "hello world"</p>
      <p>To do so you should run 'echo' in the container and have that say "hello world"

      """
command_expected: ["docker", "run", "learn/tutorial", "echo", "hello"]
command_show: ["docker", "run", "learn/tutorial", 'echo "hello world"']

result: """<p>Great! Hellooooo World!</p><p>You have just started a container and executed a program inside of it, when
        the program stopped, so did the container."""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you give the command `echo "hello world"` """,
  () -> """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  ]
tip: """
     <p>The command <code>docker run</code> takes a minimum of two arguments. An image name, and the command you want to execute
     within that image.</p>
     <p>Check the expected command below if it does not work as expected</p>
    """
})

q.push ({
html: """
      <h3>Installing things in the container</h3>
      <p>Next we are going to install a simple program (ping) in the container. The image is based upon ubuntu, so you
      can run the command <code>apt-get install -y ping</code> in the container. </p>
      <p>Note that even though the container stops right after a command completes, the changes are not forgotten.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Install 'ping' on top of the learn/tutorial image.</p>
      """
command_expected: ["docker", "run", "learn/tutorial", "apt-get", "install", "-y", "ping"]
result: """<p>That worked! You have installed a program on top of a base image. Your changes to the filesystem have been
        kept, but are not yet saved.</p>"""
intermediateresults: [
  () -> """<p>Not specifying -y on the apt-get install command will work for ping, because it has no other dependencies, but
  it will fail when apt-get wants to install dependencies. To get into the habit, please add -y after apt-get.</p>""",
]
tip: """
     <p>Don't forget to use -y for noninteractive mode installation</p>
     <p>Not specifieng -y on the apt-get install command will fail for most commands because it expects you to accept
     (y/n) but you cannot respond.
     </p>
     """
})

q.push ({
html: """
      <h3>Save your changes</h3>
      <p>After you make changes (by running a command inside a container), you probably want to save those changes.
      This will enable you to later start from this point onwards.</p>
      <p>With Docker, the process of saving the state is called <em>committing</em>. Commit basically saves the difference
      between the old image and the new state. The result is a new layer.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>First use <code>docker ps -l</code> to find the ID of the container you created by installing ping.</p>
      <p>Then save (commit) this container with the repository name 'learn/ping' </p>
      """
command_expected: ["docker", "commit", "698", "learn/ping"]
command_show: ["docker", "commit", "698", 'learn/ping']
result: """<p>That worked! Please take note that Docker has returned a new ID. This id is the <em>image id</em>.</p>"""
intermediateresults: [ () -> """You have not specified the correct repository name to commit to (learn/ping). This works, but giving your images a name
                      makes them much easier to work with."""]
tip: """<ul>
     <li>Giving just <code>docker commit</code> will show you the possible arguments.</li>
     <li>You will need to specify the container to commit by the ID you found</li>
     <li>You don't need to copy (type) the entire ID. Three or four characters are usually enough.</li>
     <li>Giving just <code>docker commit</code> will show you the possible arguments.</li>
     </ul>"""
})


q.push ({
html: """
      <h3>Run your new image</h3>
      <p>Now you have basically setup a complete, self contained environment with the 'ping' program installed. </p>
      <p>Your image can now be run on any host that runs Docker.</p>
      <p>Lets run this image on this machine.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Run the ping program to ping www.google.com</p>

      """
command_expected: ["docker", "run", 'learn/ping', 'ping', 'google.com' ]
result: """<p>That worked! Note that normally you can use Ctrl-C to disconnect. The container will keep running. This
        container will disconnect automatically.</p>"""
intermediateresults: [ () -> """You have not specified a repository name. This is not wrong, but giving your images a name
                      make them much easier to work with."""]
tip: """<ul>
     <li>Make sure to use the repository name learn/ping to run ping with</li>
     </ul>"""
})




q.push ({
html: """
      <h3>Check your running image</h3>
      <p>You now have a running container. Let's see what is going on.</p>
      <p>Using <code>docker ps</code> we can see a list of all running containers, and using <code>docker inspect</code>
      we can see all sorts of usefull information about this container.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p><em>Find the container id</em> of the running container, and then inspect the container using <em>docker inspect</em>.</p>

      """
command_expected: ["docker", "inspect", "efe" ]
result: """<p>Success! Have a look at the output. You can see the ip-address, status and other information.</p>"""
intermediateresults: [ () -> """You have not specified a repository name. This is not wrong, but giving your images a name
                      make them much easier to work with."""]
tip: """<ul>
     <li>Remember you can use a partial match of the image id</li>
     </ul>"""
currentDockerPs:
    """
    ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
    efefdc74a1d5        learn/ping:latest   ping www.google.com   37 seconds ago      Up 36 seconds
    """

})



q.push ({
html: """
      <h3>Push your image to the index</h3>
      <p>Now you have verified that your application container works, you can share it.</p>
      <p>Remember you pulled (downloaded) the learn/tutorial image from the index? You can also share your built images
      to the index by pushing (uploading) them to there. That way you can easily retrieve them for re-use and share them
      with others. </p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Push your container image learn/ping to the index</p>

      """
#command_expected: ["docker", "push", "learn/ping"]
command_expected: ["will_never_be_valid"]
command_show: ["docker", "push", "learn/ping"]
result: """"""
intermediateresults:
  [
    () ->
      $('#instructions .assignment').hide()
      $('#tips, #command').hide()

      $('#instructions .text').html("""
        <h3>Congratulations!</h3>
        <p>You have mastered the basic docker commands!</p>
        <p><strong>Your next steps</strong></p>
        <ul>
          <li><a href="/news_signup/" target="_blank" >Register for news and updates on Docker (opens in new window)</a></li>
          <li><a href="http://twitter.com/docker" target="_blank" >Follow us on twitter (opens in new window)</a></li>
          <li><a href="#" onClick="leaveFullSizeMode()">Close this tutorial, and continue with the rest of the getting started.</a></li>
        </ul>""")
      return """<p>All done!. You are now pushing a container image to the index. You can see that push, just like pull, happens layer by layer.</p>"""
  ]
tip: """<ul>
     <li><code>docker images</code> will show you which images are currently on your host</li>
     <li><code>docker push</code>is the command to push images</li>
     <li>You can only push images to your own namespace, this emulator is logged in as user 'learn'</li>

     </ul>"""
finishedCallback: () ->
  webterm.clear()
  webterm.echo( myTerminal() )

})

#
#q.push ({
#html: """
#      <h3>You are all done</h3>
#      <p>You have mastered the basic docker commands.</p>
#      """
#assignment: """
#      <h3>Sign up</h3>
#      <p></p>
#
#      """
#command_expected: ["docker", "push", "learn/ping"]
#command_show: ["docker", "push", "learn/ping"]
#result: """<p>Congratulations! Now let's get back to the getting started and the installation</p>"""
#intermediateresults: [""" """]
#tip: """
#
#     """
#})



#
#q.push ({
#html: """
#      <h3>Interactive Shell</h3>
#      <p>Now, since Docker provides you with the equivalent of a complete operating system you are able to get
#      an interactive shell (tty) <em>inside</em> of the container.</p>
#      <p>Since we want a prompt in the container, we need to start the shell program in the container. </p>
#      <p>You may never have manually started it before, but a popular one typically lives at `/bin/bash`</p>
#      """
#assignment: """
#      <h3>Assignment</h3>
#      <p>Your goal is to run the tutorial container you have
#      just downloaded and get a shell inside of it.</p>
#      """
#command_expected: ["docker", "run", "-i", "-t", "learn/tutorial", "/bin/bash"]
#result: """<p>Great!! Now you have an interactive terminal</p>"""
#intermediateresults: [
#  """<p>You seem to be almost there. Did you use <em>-i and -t</em>?</p>""",
#  """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
#  """<p>You have the command right, but the shell exits immediately, before printing anything</p>
#      <p>You will need to attach your terminal to the containers' terminal.</p>
#  """
#  ]
#tip: """Start by looking at the results of `docker run`, it shows which arguments exist"""
#})
#


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
  feedback: "feedback"
  complete: "complete"



###
  Sending events to the server
###

logEvent = (data, feedback) ->
    ajax_load = "loading......";
    loadUrl = "/tutorial/api/";
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
$('#buttonNext').click ->
  next()
  $('#results').hide()

$('#buttonFinish').click ->
  window.open(COMPLETE_URL)


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

  webterm.resize()
  data = { type: EVENT_TYPES.start }
  logEvent(data)
  next(0)

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

    if _q.currentDockerPs?
      window.currentDockerPs = _q.currentDockerPs
    else
      window.currentDockerPs = staticDockerPs

    if _q.finishedCallback?
      window.finishedCallback = q.finishedCallback
    else
      window.finishedCallback = () -> return ""

    window.immediateCallback = (input, stop) ->
      if stop == true # prevent the next event from happening
        doNotExecute = true
      else
        doNotExecute = false

      if doNotExecute != true
        console.log (input)

        data = { 'type': EVENT_TYPES.command, 'command': input.join(' '), 'result': 'fail' }

        # Was like this:  if not input.switches.containsAllOfThese(_q.arguments)
        if input.containsAllOfTheseParts(_q.command_expected)
          data.result = 'success'

          setTimeout( ( ->
            @webterm.disable()
            $('#buttonNext').focus()
          ), 1000)

          results.set(_q.result)
          console.debug "contains match"
        else
          console.debug("wrong command received")

        # call function to submit data
        logEvent(data)
      return

    window.intermediateResults = (input) ->
      if _q.intermediateresults
        results.set(_q.intermediateresults[input](), intermediate=true)
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

