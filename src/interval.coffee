Utils = require './utils'

class Interval
  constructor: (@type, { @name, @duration, @startedAt, @stoppedAt }) ->

  startedAt: undefined
  stoppedAt: undefined

  timePassed: ->
    new Date - @startedAt

  timeOverstayed: ->
    @timePassed() - @duration

  isFinished: ->
    @timeOverstayed() >= 0

module.exports = Interval
