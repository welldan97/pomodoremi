fs = require 'fs'
_ = require 'lodash'

Utils = require './utils'
Timer = require './timer'
IntervalFactory = require './interval-factory'

setUpConfigs = require './pomodoremi/set-up-configs'

class Pomodoremi
  EVENTS = ['start', 'stop', 'update', 'finish', 'overstay']

  constructor: (options = {}) ->
    @timer = new Timer()
    setUpConfigs(this, options)
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

  _loadModules: (modules) ->
    commandsList = _(modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) => _.merge(this, commands)

    helpList = _(modules).pluck('help').compact().value()
    _.forEach helpList, (help) => _.merge(@help, help)

    _.forEach EVENTS, (event) =>
      @timer.on event, (interval) ->
        Utils.callAll modules, event, interval


module.exports = Pomodoremi
