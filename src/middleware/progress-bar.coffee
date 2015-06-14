Utils = require '../utils'
Progress = require 'progress'

class ProgressBar
  DEFAULT_OPTIONS = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  constructor: (@options = DEFAULT_OPTIONS) ->

  start: (type, @length, cb) ->
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
    cb()

module.exports = ProgressBar
