

q = []

define [], () ->

  return q


## 0

q.push ({
slug: "docker-version"

title: "Getting started"
html: """
      <p>There is the Docker Engine, a server process which manages starting and stopping of containers
      containers. and the client of the Docker Engine, it acts as a remote control to the server process. In this
      emulator both execute on the same host.</p>
      """
assignment: "<p>Check which version of Docker is running</p>"
tip: "<p>Try typing <code>docker</code> to see the full list of accepted arguments</p>
      <p>This emulator provides only a limited set of shell and Docker commands, so some commands may not work as expected</p>"
command_expected: ['docker', 'version']
result: """<p>Well done! Let's move to the next assignment.</p>"""
})

## 1
q.push ({
slug: "docker-search"
title: "Searching for images"
html: """
      <p>The easiest way to get started is to use a container image from someone else.
      Container images are available from repositories on the Docker Index, a central place to store and share
      built images. You can find them online at
      <a href="#1" onClick="window.open('http://index.docker.io','Docker Index','width=1000,height=900,left=50,top=50,menubar=0')";>index.docker.io</a>
      and by using the commandline.</p>
      """
assignment: """
      <p>Use the commandline to find a repository called 'tutorial'.</p>
      """
command_expected: ['docker', 'search', 'tutorial']
result: """<p>You found it! Look at the first result. It's name is learn/tutorial, 'learn' is the namespace and 'tutorial' is the repository name.</p>"""
tip: "the format is <code>docker search &lt;string&gt;</code>"
})

## 2
q.push ({
slug: "docker-pull"
title: "Downloading container images"
html: """
      <p>Look at the output. You have found a repository called learn/tutorial. Using <code>docker pull</code>
      the Docker daemon will download the container images contained in this repository.</p>
      """
#<p>Notice that repository names on the Docker Index are composed as &lt;username&gt;/&lt;repository&gt;. A
#      group of special, official repositories can be retrieved by just their name &lt;repository&gt;.</p>
assignment:
      """
      <p>Pull (download) the content of the repository you have just found.</p>
      """
command_expected: ['docker', 'pull', 'learn/tutorial']
# ToDo: Fixme - display and downloading of all ubuntu version images does not make a lot of sense..
result: """<p>Cool, well done! Now look at the results. You'll see that Docker has downloaded a number of images.</p>
           <p>In Docker images are mostly built on top of other images. When you download the top one all dependent images will be downloaded as well.</p>
           <p>Amongst other the 'ubuntu' base image has also been downloaded.</p>"""
tip: """<ul><li>Make sure to pull the full name of the repository e.g. 'learn/tutorial'</li>
     <li>Look under "show expected command" if you're stuck.</li></ul>
     """
})

## 3
q.push ({
slug: "hello-world"
title: "Hello world from a container"
html: """
      <p>You can think about containers as a process in a box. The box contains everything the process might need, so
      it has the filesystem, system libraries, shell and such, but by default none of it is started or run.<p>
      <p>You 'start' a container <em>by</em> running a process in it. This process is the only process run, so when
      it completes the container is fully stopped.
      """
assignment: """
      <p>Use the 'ubuntu' base image to output "hello world"</p>
      <p>To do so you wil run the program 'echo' in a container and have that show "hello world"</p>

      """
command_expected: ["docker", "run", "ubuntu", "echo", "hello"]
command_show: ["docker", "run", "ubuntu", 'echo "hello world"']

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

## 4
q.push ({
slug: "install-fortunes"
title: "Installing things in the container"
html: """
      <p>Next we are going to install a simple program (fortunes) in the container. The image is based upon ubuntu, so you
      can run the command <code>apt-get install -y fortunes</code> in the container. </p>
      <p>Note that even though the container stops right after a command completes, the changes are not forgotten.</p>
      """
assignment: """
      <p>Install the program 'fortunes' on top of the ubuntu image.</p>
      """
command_expected: ["docker", "run", "ubuntu", "apt-get", "install", "-y", "fortunes"]
result: """<p>That worked! You have installed a program on top of a base image. Your changes to the filesystem have been
        kept, but are not yet saved.</p>"""
intermediateresults: [
  () -> """<p>Not specifying -y on the apt-get install command will work for ping, because it has no other dependencies, but
  it will fail when apt-get wants to install dependencies. To get into the habit, please add -y after apt-get.</p>""",
]
tip: """
     <p>Don't forget to use -y for noninteractive mode installation</p>
     <p>Not specifying -y on the apt-get install command will fail for most commands because it expects you to accept
     (y/n) but you cannot respond.
     </p>
     """
})

## 5
q.push ({
slug: "ps-latest"
title: "Save your changes"
html: """
      <p>After you make changes (by running a command inside a container), you probably want to save those changes.
      This will enable you to later start from this point onwards.</p>
      <p>With Docker, the process of saving the state is called <em>committing</em>. Commit basically saves the difference
      between the old image and the new state. The result is a new image, it contains only the files which are new or modified.</p>
      """
assignment: """
      <p>First use <code>docker ps -l</code> to find the ID of the container you created by installing fortunes.</p>
      <p>Then save (commit) this container.</p>
      """
command_expected: ["docker", "commit", "991"]
command_show: ["docker", "commit", "991"]
result: """<p>That worked! Please take note that Docker has returned a new ID. This id is the <em>image id</em>.</p>"""
intermediateresults: [ () -> """You have not specified the correct repository name to commit to (learn/ping). This works, but giving your images a name
                      makes them much easier to work with."""]
tip: """<ul>
     <li>Giving just <code>docker commit</code> will show you the possible arguments.</li>
     <li>You will need to specify the container to commit by the ID you found</li>
     <li>You don't need to copy (type) the entire ID. Three or four characters are usually enough.</li>
     </ul>"""
})

###

## 6
q.push ({
html: """
      <h3>Test your new image</h3>
      <p>Now you have basically setup a complete, self contained environment with the 'ping' program installed. </p>
      <p>Your image can now be run on any host that runs Docker.</p>
      <p>Lets run this image on this machine.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Run the image just created with ping and ping www.google.com</p>
      """
# ToDo: fix img name
command_expected: ["docker", "run", '698', 'ping', 'google.com' ]
result: """<p>That worked! Note that normally you can use Ctrl-C to disconnect and leave the container running. This
        container will disconnect automatically.</p>"""
# ToDo: fix repo name
tip: """<ul>
     <li>You will need to specify the <em>image</em> id this time. Later you will learn how to give it a name instead.</li>
     </ul>"""
})
###


## 7
q.push ({
title: "Login with your Docker account"
html: """
      <p>A Docker account is your central identity in the Docker ecosystem and gives you access to a number of usefull services.</p>
      <p>To finish this tutorial you will need to have or create one (it's free).</p>
      <p>If you don't have a Docker Account yet, you can <strong><a href="#8" class='' onclick="window.open('http://www.docker.io/account/signup/','Docker','width=1000,height=900,left=50,top=50,menubar=0')">create one here.</a></strong></p>
      <p>The docker commandline allows you to login with <code>docker login</code>.</p>
      """
assignment: """
      <p>Login with your Docker account. Create one if needed.</p>
      """
command_expected: ["docker", "login", "cannot match"]
command_show: ["docker", "login"]
result: """<p>Great!</p>"""
tip:  """<ul><li>Make sure to also verify your e-mail</li><li>When you succesfully complete this tutorial we will reward you with a badge on your public profile!</li></ul>"""

})


## 8
q.push ({
title: "Tag your image for storage on the Docker Index"
html: """
      <p>Now you know your Docker username you can prepare and name the 'ping' container image you've built in
      step 5 so it is easy to reference and ready for pushing to the index.</p>
      """
assignment: () ->
      """
      <p>Find the last image you created and tag it with #{docker_username}/ping.</p>
      """
command_expected: ["docker", "tag", "eff", "ping"]
command_show: ["docker", "tag", "eff", "your_name/ping"]

# ToDo: Fix way to skip the login step
result: """<p>Great!</p>"""
tip:  """<ul><li><code>docker images</code> shows a full list of images currently loaded on your host</li>
             <li>Learn more about tagging by giving <code>docker tag</code></li>
      <li>When you succesfully complete this tutorial we will reward you with a badge on your public profile!</li>
      <li>If you do not want to create an account, but still want to finish this tutorial, you can just skip to question 9.</li>
</ul>"""

})


## 9
q.push ({
title: "Push your image to the index"
html: """
      <p>Now you have logged in and labelled your container correctly you can push it to the Index.</p>
      <p>This will allow you to download it on another host or share it with coworkers and friends.</p>
      """
assignment: """
      <p>Push the container image you just tagged to the Docker Index.</p>
      <small>(this emulator will not actually create a repository)</small>
      """
#command_expected: ["docker", "push", "learn/ping"]
command_expected: ["will_never_be_valid"]
# Fixme: fix this command
command_show: ["docker", "push", "learn/ping"]
result: """"""
intermediateresults:
  [
    () ->
      $('#instructions .assignment').hide()
      $('#tips, #command').hide()

      $('#instructions .text').html("""
        <div class="complete">
          <h3>Congratulations!</h3>
          <p>You have mastered the basic docker commands!</p>
          <p><strong>Did you enjoy this tutorial? Share it!</strong></p>
          <p>
            <a href="mailto:?Subject=Check%20out%20the%20Docker%20interactive%20tutorial!&Body=%20https://www.docker.io/gettingstarted/"><img src="/static/img/email.png"></a>
            <a href="http://www.facebook.com/sharer.php?u=https://www.docker.io/gettingstarted/"><img src="/static/img/facebook.png"></a>
            <a href="http://twitter.com/share?url=https://www.docker.io/gettingstarted/&text=%20Check+out+the+docker+tutorial!"><img src="/static/img/twitter.png"></a>
          </p>
          <h3>Your next steps</h3>
          <ol>
            <li><a href="/news_signup/" target="_blank" >Register</a> for news and updates on Docker (opens in new window)</li>
            <li><a href="http://twitter.com/docker" target="_blank" >Follow</a> us on twitter (opens in new window)</li>
            <li><a href="#" onClick="leaveFullSizeMode()">Close</a> this tutorial, and continue with the rest of the getting started.</li>
          </ol>
          <p> - Or - </p>
          <p>Continue to learn about the way to automatically build your containers from a file. </p><p><a href="/learn/dockerfile/" class='btn btn-primary secondary-action-button'>Start Dockerfile tutorial</a></p>

        </div>
        """)


      data = { type: EVENT_TYPES.complete }
      logEvent(data)

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

