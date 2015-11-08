Utils = require './utils'

class Interval
  constructor: (@type, options) ->
    @name = options['name'] if options
    @length = Interval.lengths[@type]

  startedAt: undefined
  stoppedAt: undefined

  timePassed: ->
    new Date - @startedAt


module.exports = Interval
