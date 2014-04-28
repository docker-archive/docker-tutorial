define [], () ->

  settings = {
    DEBUG: true,
    LOG_EVENTS_TO_SERVER: false,

    API_URI: "/tutorial/api/",

    EMULATOR_VERSION: '2.0',

    EVENT_TYPES: {
      none: "none"
      start: "start"
      command: "command"
      next: "next"
      peek: "peek"
      feedback: "feedback"
      complete: "complete"
      render: "render"
    }

  }

  return settings