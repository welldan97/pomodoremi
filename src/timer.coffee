Utils = require './utils'
class Timer
  ONE_MINUTE = Utils.toMs(1)

  constructor: (@delay = ONE_MINUTE) ->

  start: (@length) ->
    @processed = 0
    @stopped = false
    setTimeout (=> @process()), @delay

  stop: ->
    @stopped = true

  process: ->
    return if @stopped
    @processed += 1
    if (@processed - 1) * @delay >= @length
      @onOverstay? @processed * @delay - @length
    else if @processed * @delay >= @length
      @onFinish?()
    else
      @onNotify? @processed * @delay
    setTimeout (=> @process()), @delay

  notify: (@onNotify) ->
  overstay: (@onOverstay) ->
  finish: (@onFinish) ->

module.exports = Timer
