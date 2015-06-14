CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
s = require 'underscore.string'
async = require 'async'
require 'coffee-script/register'

Tags = require './modules/tags'
Track = require './modules/track'
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

    modules: [
      new Track
      new Tags
      new CommandLineLog
      new Notifier
    ]

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    _.merge(Interval, lengths: @lengths)
    commands = _(@modules).pluck('commands').compact().value()
    _.merge(this, commands)
    @timer = new Timer()

    @timer.onStart =>
      Utils.callAll @modules, 'start', @interval

    @timer.onStop =>
      Utils.callAll @modules, 'stop', @interval

    @timer.onUpdate (passed) =>
      Utils.callAll @modules, 'update', @interval, passed

    @timer.onFinish =>
      Utils.callAll @modules, 'finish', @interval

    @timer.onOverstay (delay) =>
      Utils.callAll @modules, 'overstay', @interval, delay

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
