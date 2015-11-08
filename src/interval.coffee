Utils = require './utils'

class Interval
  constructor: (@type, { @name, @duration, @startedAt, @stoppedAt }) ->

  timePassed: ->
    new Date - @startedAt

  timeOverstayed: ->
    @timePassed() - @duration

  isFinished: ->
    @timeOverstayed() >= 0

module.exports = Interval
