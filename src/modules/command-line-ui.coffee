_ = require 'lodash'
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
    @isSessionStarted = false
    @isSessionClosing = false

  start: (interval, cb) ->
    console.log("(#{Utils.formatDate(new Date)})") unless @isSessionStarted
    @isSessionStarted = true
    @isSessionClosing = false
    switch interval.type
      when 'work'
        console.log interval.name
      when 'shortBreak'
        console.log '----'
      when 'longBreak'
        console.log '===='


    @progress = new Progress @options...
    @progress.update 0, status: Utils.formatMin(interval.duration)
    cb()

  update: (interval, cb) ->
    status = Utils.formatMin(interval.duration - interval.timePassed())
    @progress.update interval.timePassed() / interval.duration, { status }
    cb()

  finish: (interval, cb) ->
    @progress.update 1, { status: 0 }
    @progress = undefined
    cb()

  stop: (interval, cb) ->
    @isSessionClosing = true
    @progress.update 1, { status: 0 } if @progress
    console.log "  \##{interval.tags.join(' #')}" unless _.isEmpty interval.tags
    setTimeout (=> @_closeSession()), 10000
    cb()

  _closeSession: ->
    if @isSessionClosing
      @isSessionClosing = false
      @isSessionStarted = false
      console.log("(#{Utils.formatDate(new Date)})\n")

module.exports = CommandLineUI
