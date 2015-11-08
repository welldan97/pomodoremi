CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

fs = require 'fs'
_ = require 'lodash'
require 'coffee-script/register'

Tags = require './modules/tags'
Track = require './modules/track'
CommandLineUI = require './modules/command-line-ui'
Notifier = require './modules/notifier'
Debug = require './modules/debug'

Utils = require './utils'
Timer = require './timer'
IntervalFactory = require './interval-factory'

config =
  # if Utils.canRequire CONFIG_PATH
    # require CONFIG_PATH
  # else
    ->

class Pomodoremi
  DEFAULT_OPTIONS =
    help:
      start: -> ['start [name]', 'starts Pomodoro']
      shortBreak: -> ['shortBreak', 'starts short break']
      longBreak: -> ['longBreak', 'starts long break']
      stop: -> ['stop', 'stops Pomodoro or break']

    durations:
      work: Utils.toMs(25)
      shortBreak: Utils.toMs(5)
      longBreak: Utils.toMs(15)

    modules: [
      # new Track
      # new Tags
      # new CommandLineUI
      # new Notifier
      new Debug
    ]

  constructor: (options = {}) ->

    _.merge(this, DEFAULT_OPTIONS, options)
    config.apply this
    @timer = new Timer()
    commandsList = _(@modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) => _.merge(this, commands)
    helpList = _(@modules).pluck('help').compact().value()
    _.forEach helpList, (help) => _.merge(@help, help)

    _.forEach ['start', 'stop', 'update', 'finish', 'overstay'], (event) =>
      @timer.on event, (args...) =>
        Utils.callAll @modules, event, @interval, args...

    { @Work, @ShortBreak, @LongBreak } = IntervalFactory @durations

  start: (args..., cb) ->
    @interval = new @Work { name: args[0] }
    @timer.start @interval
    cb()

  shortBreak: (cb) ->
    @interval = new @ShortBreak
    @timer.start @interval
    cb()

  longBreak: (cb) ->
    @interval = new @LongBreak
    @timer.start @interval
    cb()

  stop: (cb) ->
    @timer.stop()
    cb()

module.exports = Pomodoremi
