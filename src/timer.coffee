Utils = require './utils'
class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->

  start: (@length) ->
    @processed = 0
    @started = true
    setTimeout (=> @process()), @delay

  stop: ->
    @started = false

  process: ->
    return unless @started
    @processed += 1
    if (@processed - 1) * @delay >= @length
      @onOverstay? @processed * @delay - @length
    else if @processed * @delay >= @length
      @onFinish?()
    else
      @onUpdate? @processed * @delay
    setTimeout (=> @process()), @delay

  update: (@onUpdate) ->
  overstay: (@onOverstay) ->
  finish: (@onFinish) ->

module.exports = Timer
