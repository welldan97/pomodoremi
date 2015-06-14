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
    help:
      start: -> ['start [name]', 'starts Pomodoro']
      shortBreak: -> ['shortBreak', 'starts short break']
      longBreak: -> ['longBreak', 'starts long break']
      stop: -> ['stop', 'stops Pomodoro or break']

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

    _.merge(this, DEFAULT_OPTIONS, options)
    config.apply this
    _.merge(Interval, lengths: @lengths)
    @timer = new Timer()
    commandsList = _(@modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) => _.merge(this, commands)
    helpList = _(@modules).pluck('help').compact().value()
    _.forEach helpList, (help) => _.merge(@help, help)

    _.forEach ['start', 'stop', 'update', 'finish', 'overstay'], (event) =>
      @timer.on event, (args...) =>
        Utils.callAll @modules, event, @interval, args...

  start: (args..., cb) ->
    name = args[0] ? 'Pomodoro'
    @interval = new Interval('work', { name })
    @timer.start @interval
    cb()

  shortBreak: (cb) ->
    @interval = new Interval('shortBreak')
    @timer.start @interval
    cb()

  longBreak: (cb) ->
    @interval = new Interval('longBreak')
    @timer.start @interval
    cb()

  stop: (cb) ->
    @timer.stop()
    cb()

module.exports = Pomodoremi
