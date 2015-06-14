Utils = require './utils'

class Interval
  constructor: (@type, options) ->
    @name = options['name'] if options
    @length = Interval.lengths[@type]

module.exports = Interval
