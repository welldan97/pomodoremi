Utils = require '../utils'
Progress = require 'progress'

class CommandLineLog
  DEFAULT_OPTIONS = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  constructor: (@options = DEFAULT_OPTIONS) ->

  start: (type, name, @length, cb) ->
    switch type
      when 'work'
        # console.log("(#{Utils.formatDate(new Date)})") unless @type?
        console.log name
      when 'shortBreak'
        console.log '----'
      when 'longBreak'
        console.log '===='


    @progress = new Progress @options...
    @progress.update 0, status: @length
    cb()

  notify: (type, passed, cb) ->
    passedInMins = @length * (passed / Utils.toMs(@length))
    status = @length - Math.floor(passedInMins)
    @progress.update passed / Utils.toMs(@length), { status }
    cb()

  finish: (type, cb) ->
    @progress.update 1, { status: 0 }
    @progress = undefined
    cb()

  reset: (cb) ->
    @progress.update 1, { status: 0 } if @progress
    # console.log "  \##{@tags.join(' #')}" unless _.isEmpty @tags
    cb()

module.exports = CommandLineLog
