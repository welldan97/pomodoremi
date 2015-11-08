EventEmitter = require('events').EventEmitter

Utils = require './utils'

class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->
    @on = EventEmitter::on
    @emit = EventEmitter::emit

  start: (@interval) ->
    @finishEmitted = false

    @length = @interval.length
    @emit 'stop', @interval.timePassed() if @startedAt
    @processed = 0
    @startedAt = new Date()
    @interval.startedAt = @startedAt
    @emit 'start'
    @_schedule(@startedAt)

  stop: ->
    @emit 'stop', @interval.timePassed() if @startedAt

    @startedAt = undefined

  process: (startedAt) ->
    return unless @startedAt
    return unless @startedAt == startedAt

    @processed += 1
    if !@interval.isFinished()
      @emit 'update', @processed * @delay
    else if !@finishEmitted
      @emit 'finish'
      @finishEmitted = true
    else
      @emit 'overstay', @processed * @delay - @length

    @_schedule(startedAt)

  _schedule: (startedAt) ->
    setTimeout (=> @process(startedAt)), @delay

module.exports = Timer
