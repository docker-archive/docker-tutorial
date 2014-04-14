
define ['parsers/main'], ( Parser ) ->

  ###
  The interpreter
  ###
  @interpreter = (input, term) ->

    inputs = input.split(" ")
    command = inputs[0]

    if inputs[0] is 'hi'
      term.echo 'hi there! What is your name??'
      term.push (input, term) ->
        term.echo input + ' is a pretty name'

    if inputs[0] is 'docker'
      parser = new Parser(inputs, term)
      result = parser.run()

      if result and result.answered
        alert result.answered


  @basesettings = {
    prompt: 'you@tutorial:~$ ',
    greetings: """
               Welcome to the interactive Docker tutorial
              """
  }

  @webterm = $('#terminal').terminal(@interpreter, basesettings)




  return @webterm