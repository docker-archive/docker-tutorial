define [], () ->

  class Question

    constructor: ->
      log("constructor called")

    log = (logline) ->
      console.log("Question: " + logline)

  return Question