EventEmitter = require('events').EventEmitter

Utils = require './utils'

class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->
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
      @emit 'overstay', @interval.timePassed() - @interval.length

    @_schedule(interval)

  _schedule: (interval) ->
    setTimeout (=> @process(interval)), @delay

module.exports = Timer
