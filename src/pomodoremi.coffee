fs = require 'fs'
_ = require 'lodash'

Utils = require './utils'
Timer = require './timer'
IntervalFactory = require './interval-factory'

setUpConfigs = require './pomodoremi/set-up-configs'
setUpModules = require './pomodoremi/set-up-modules'

class Pomodoremi
  constructor: (options = {}) ->
    @timer = new Timer()
    setUpConfigs(this, options)
    setUpModules(this, @mod)
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



module.exports = Pomodoremi
