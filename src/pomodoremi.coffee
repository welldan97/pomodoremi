fs = require 'fs'
_ = require 'lodash'
require 'coffee-script/register'

Tags = require './modules/tags'
CommandLineUI = require './modules/command-line-ui'
Notifier = require './modules/notifier'
# Debug = require './modules/debug'

Utils = require './utils'
Timer = require './timer'
IntervalFactory = require './interval-factory'

class Pomodoremi
  PERSONAL_CONFIG_PATH = process.env.POMODOREMI_CONFIG_PATH ?
    "#{process.env.HOME}/.pomodoremi/config"
  EVENTS = ['start', 'stop', 'update', 'finish', 'overstay']
  DEFAULT_OPTIONS =
    durations:
      work: Utils.toMs(25)
      shortBreak: Utils.toMs(5)
      longBreak: Utils.toMs(15)

    modules: [
      new Tags()
      new CommandLineUI()
      new Notifier()
      # new Debug
    ]

  constructor: (options = {}) ->
    @timer = new Timer()
    @_applyConfig(options)
    @_loadModules(@modules)
    { @Work, @ShortBreak, @LongBreak } = IntervalFactory @durations

  help:
    start: -> ['start [name]', 'starts Pomodoro']
    shortBreak: -> ['shortBreak', 'starts short break']
    longBreak: -> ['longBreak', 'starts long break']
    stop: -> ['stop', 'stops Pomodoro or break']

  start: (args..., cb) ->
    interval = new @Work { name: args[0] }
    @timer.start interval
    cb()

  shortBreak: (cb) ->
    interval = new @ShortBreak
    @timer.start interval
    cb()

  longBreak: (cb) ->
    interval = new @LongBreak
    @timer.start interval
    cb()

  stop: (cb) ->
    @timer.stop()
    cb()

  _applyConfig: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, options)
    personalConfigLoad =
      if Utils.canRequire PERSONAL_CONFIG_PATH
        require PERSONAL_CONFIG_PATH
      else
        console.log 'no personal config'
        ->
    personalConfigLoad.apply this

  _loadModules: (modules) ->
    commandsList = _(modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) => _.merge(this, commands)

    helpList = _(modules).pluck('help').compact().value()
    _.forEach helpList, (help) => _.merge(@help, help)

    _.forEach EVENTS, (event) =>
      @timer.on event, (interval) ->
        Utils.callAll modules, event, interval


module.exports = Pomodoremi
