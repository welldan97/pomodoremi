Utils = require './utils'

class Interval
  constructor: (@type, options) ->
    @name = options['name'] if options
    @length = Interval.lengths[@type]

  start: ->
    @startedAt = new Date

  stop: ->
    @stoppedAt = new Date

module.exports = Interval
