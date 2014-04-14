#window = this

root = exports ? this


###  =======================================
    Extend protorypes
=======================================  ###

String.prototype.beginsWith = (string) ->
  ###
  Check if 'this' string starts with the inputstring.
  ###
  return(this.indexOf(string) is 0)

Array.prototype.containsAllOfThese = (inputArr) ->
  ###
  This function compares all of the elements in the inputArr
  and checks them one by one if they exist in 'this'. When it
  finds an element to not exist, it returns false.
  ###
  me = this
  valid = false

  if inputArr
    valid = inputArr.every( (value) ->
      if me.indexOf(value) == -1
        return false
      else
        return true
    )
  return valid


Array.prototype.containsAllOfTheseParts = (inputArr) ->
  ###
  This function is like containsAllofThese, but also matches partial strings.
  ###

  me = this
  if inputArr
    valid = inputArr.every( (value) ->
      for item in me
        if item.match(value)
          return true

      return false
    )
  return valid


###  =======================================
    Simple util functions
=======================================  ###


root.utils =

  parseInput: (inputs) ->
    command = inputs[1]
    switches = []
    switchArg = false
    switchArgs = []
    imagename = ""
    commands = []
    j = 0

    # parse args
    for input in inputs
      if input.startsWith('-') and imagename == ""
        switches.push(input)
        if switches.length > 0
          if not ['-i', '-t', '-d'].containsAllOfThese([input])
            switchArg = true
      else if switchArg == true
        # reset switchArg
        switchArg = false
        switchArgs.push(input)
      else if j > 1 and imagename == ""
        # match wrong names
        imagename = input
      else if imagename != ""
        commands.push (input)
      else
        # nothing?
      j++

    parsed_input = {
      'switches': switches.sortBy(),
      'switchArgs': switchArgs,
      'imageName': imagename,
      'commands': commands,
    }
    return parsed_input


  util_slow_lines: (term, paragraph, keyword, finishedCallback) ->

    if keyword
      lines = paragraph(keyword).split("\n")
    else
      lines = paragraph.split("\n")

    term.pause()
    i = 0
    # function calls itself after timeout is done, untill
    # all lines are finished
    foo = (lines) ->
      self.setTimeout ( ->
        if lines[i]
          term.echo (lines[i])
          i++
          foo(lines)
        else
          term.resume()
          finishedCallback()
      ), 1000

    foo(lines)

    wait = (term, time, dots) ->
      term.echo "starting to wait"
      interval_id = self.setInterval ( -> dots ? term.insert '.'), 500

      self.setTimeout ( ->
        self.clearInterval(interval_id)
        output = term.get_command()
        term.echo output
        term.echo "done "
      ), time

  timestamp: (d) ->
    if not d
      d = new Date()

    # padding function
    s = (a,b) ->
      return(1e15+a+"").slice(-b)

    # default date parameter
    if (typeof d is 'undefined')
      d = new Date()

    # return ISO datetime
    return d.getFullYear() + '-' +
        s(d.getMonth()+1,2) + '-' +
        s(d.getDate(),2) + ' ' +
        s(d.getHours(),2) + ':' +
        s(d.getMinutes(),2) + ':' +
        s(d.getSeconds(),2)
