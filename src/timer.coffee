Utils = require './utils'
class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->

  start: (@length) ->
    if @startedAt
      @_onStop? @processed * @delay
    @processed = 0
    @startedAt = new Date()
    @_onStart?()
    @_schedule(@startedAt)

  stop: ->
    if @startedAt
      @_onStop? @processed * @delay

    @startedAt = undefined

  process: (startedAt) ->
    return unless @startedAt
    return unless @startedAt == startedAt

    @processed += 1
    if (@processed - 1) * @delay >= @length
      @_onOverstay? @processed * @delay - @length
    else if @processed * @delay >= @length
      @_onFinish?()
    else
      @_onUpdate? @processed * @delay
    @_schedule(startedAt)

  onStart: (@_onStart) ->
  onStop: (@_onStop) ->
  onUpdate: (@_onUpdate) ->
  onFinish: (@_onFinish) ->
  onOverstay: (@_onOverstay) ->

  _schedule: (startedAt) ->
    setTimeout (=> @process(startedAt)), @delay

module.exports = Timer
