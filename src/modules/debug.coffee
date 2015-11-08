_ = require 'lodash'
class Debug
  constructor: ->
    _.forEach ['start', 'stop', 'update', 'finish', 'overstay'], (event) =>
      this[event] = (args...) ->
        console.log event, args...

module.exports = Debug
