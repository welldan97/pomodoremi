EventEmitter = require('events').EventEmitter

Utils = require './utils'

class Timer
  DEFAULT_PERIOD = Utils.toMs(1)

  constructor: (@period = DEFAULT_PERIOD) ->
    @on = EventEmitter::on
    @emit = EventEmitter::emit

  start: (interval) ->
    @finishEmitted = false
    @processed = 0

    @stop()

    @interval = interval
    @interval.startedAt = new Date()
    @emit 'start', @interval

    @_schedule(interval)

  stop: ->
    return unless @interval?
    @interval.stoppedAt = new Date()
    @emit 'stop', @interval
    @interval = undefined

  process: (interval) ->
    return unless @interval?
    return unless @interval == interval

    @processed += 1
    if !@interval.isFinished()
      @emit 'update', @interval
    else if !@finishEmitted
      @emit 'finish', @interval
      @finishEmitted = true
    else
      @emit 'overstay', @interval

    @_schedule(interval)

  _schedule: (interval) ->
    setTimeout (=> @process(interval)), @period

module.exports = Timer
