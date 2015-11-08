Utils = require './utils'

class Interval
  constructor: (@type, options) ->
    @name = options['name'] if options
    @length = Interval.lengths[@type]

  start: ->
    @startedAt = new Date

  stop: ->
    @stoppedAt = new Date

  timePassed: ->
    new Date - @startedAt

module.exports = Interval
