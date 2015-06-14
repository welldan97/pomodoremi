Utils = require '../utils'
Progress = require 'progress'

class CommandLineUI
  DEFAULT_OPTIONS = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  constructor: (@options = DEFAULT_OPTIONS) ->

  start: (interval, cb) ->
    @length = interval.length
    switch interval.type
      when 'work'
        console.log interval.name
        # console.log("(#{Utils.formatDate(new Date)})") unless @type?
      when 'shortBreak'
        console.log '----'
      when 'longBreak'
        console.log '===='


    @progress = new Progress @options...
    @progress.update 0, status: Utils.formatMin(@length)
    cb()

  update: (interval, passed, cb) ->
    status = Utils.formatMin(@length - passed)
    @progress.update passed / @length, { status }
    cb()

  finish: (interval, cb) ->
    @progress.update 1, { status: 0 }
    @progress = undefined
    cb()

  stop: (interval, delay, cb) ->
    @progress.update 1, { status: 0 } if @progress
    # console.log "  \##{@tags.join(' #')}" unless _.isEmpty @tags
    # console.log("(#{Utils.formatDate(new Date)})\n") unless @type?
    cb()

module.exports = CommandLineUI
