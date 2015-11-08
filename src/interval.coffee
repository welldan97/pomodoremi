Utils = require './utils'

class Interval
  constructor: (@type, { @name, @length, @startedAt, @stoppedAt }) ->

  startedAt: undefined
  stoppedAt: undefined

  timePassed: ->
    new Date - @startedAt

  isFinished: ->
    @timePassed() - @length >= 0

module.exports = Interval
