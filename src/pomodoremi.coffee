CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
require 'coffee-script/register'

Tags = require './modules/tags'
Track = require './modules/track'
CommandLineUI = require './modules/command-line-ui'
Notifier = require './modules/notifier'

Utils = require './utils'
Timer = require './timer'
Interval = require './interval'
config = require CONFIG_PATH

class Pomodoremi
  DEFAULT_OPTIONS =
    lengths:
      work: Utils.toMs(25)
      shortBreak: Utils.toMs(5)
      longBreak: Utils.toMs(15)

    modules: [
      new Track
      new Tags
      new CommandLineUI
      new Notifier
    ]

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    _.merge(Interval, lengths: @lengths)
    commandsList = _(@modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) =>
      _.merge(this, commands)
    @timer = new Timer()

    _.forEach ['start', 'stop', 'update', 'finish', 'overstay'], (event) =>
      @timer.on event, (args...) =>
        Utils.callAll @modules, event, @interval, args...

  start: (name = 'Pomodoro') ->
    @interval = new Interval('work', { name })
    @timer.start @interval

  shortBreak: ->
    @interval = new Interval('shortBreak')
    @timer.start @interval

  longBreak: ->
    @interval = new Interval('longBreak')
    @timer.start @interval

  stop: ->
    @timer.stop()

module.exports = Pomodoremi
