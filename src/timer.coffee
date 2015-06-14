Utils = require './utils'
class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->

  start: (@length) ->
    @processed = 0
    @startedAt = new Date()
    startedAt = @startedAt
    setTimeout (do (startedAt) => => @process(startedAt)), @delay

  stop: ->
    @startedAt = false

  process: (startedAt) ->
    return unless @startedAt
    return unless @startedAt == startedAt
    @processed += 1
    if (@processed - 1) * @delay >= @length
      @onOverstay? @processed * @delay - @length
    else if @processed * @delay >= @length
      @onFinish?()
    else
      @onUpdate? @processed * @delay
    setTimeout ( => @process(startedAt)), @delay

  update: (@onUpdate) ->
  overstay: (@onOverstay) ->
  finish: (@onFinish) ->

module.exports = Timer
