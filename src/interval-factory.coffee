_ = require 'lodash'
Interval = require './interval'

module.exports = ({ work, shortBreak, longBreak }) ->
  class Work extends Interval
    DEFAULT_OPTIONS =
      type: 'work'
      duration: work
      name: 'Pomodoro'

    constructor: (options) ->
      super _.merge {}, DEFAULT_OPTIONS, options


  class ShortBreak extends Interval
    DEFAULT_OPTIONS =
      type: 'shortBreak'
      duration: shortBreak
    constructor: (options) ->
      super _.merge {}, DEFAULT_OPTIONS, options

  class LongBreak extends Interval
    DEFAULT_OPTIONS =
      type: 'longBreak'
      duration: longBreak
    constructor: (options) ->
      super _.merge {}, DEFAULT_OPTIONS, options

  { Work, ShortBreak, LongBreak }
