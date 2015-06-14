CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
s = require 'underscore.string'
require 'coffee-script/register'

Tags = require './modules/tags'
CommandLineLog = require './modules/command-line-log'
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

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    _.merge(Interval, lengths: @lengths)
    @modules = []
    @modules.push new CommandLineLog
    @modules.push new Notifier
    @modules.push new Tags
    _.merge(this, @modules[2].commands)

    @timer = new Timer()

    @timer.onStart =>
      @startTime = new Date
      @tags = []
      @modules[0].start(@interval, ->)

    @timer.onStop =>
      @stopTime = new Date
      @modules[0].stop(@interval, ->)

    @timer.onUpdate (passed) =>
      @modules[0].update(@interval, passed, ->)

    @timer.onFinish =>
      @modules[0].finish(@interval, ->)
      @modules[1].finish(@interval, ->)

    @timer.onOverstay (delay) =>
      @modules[1].overstay(@interval, delay, ->)

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
    @type = undefined
    @timer.stop()

module.exports = Pomodoremi
