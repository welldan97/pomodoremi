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
    @emit 'start'

    @_schedule(interval)

  stop: ->
    return unless @interval?
    @interval.stoppedAt = new Date()
    @emit 'stop', @interval.timePassed()
    @interval = undefined

  process: (interval) ->
    return unless @interval?
    return unless @interval == interval

    @processed += 1
    if !@interval.isFinished()
      @emit 'update', @interval.timePassed()
    else if !@finishEmitted
      @emit 'finish'
      @finishEmitted = true
    else
      @emit 'overstay', @interval.timeOverstayed()

    @_schedule(interval)

  _schedule: (interval) ->
    setTimeout (=> @process(interval)), @period

module.exports = Timer
