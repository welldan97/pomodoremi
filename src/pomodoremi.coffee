CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
s = require 'underscore.string'
require 'coffee-script/register'

CommandLineLog = require './modules/command-line-log'
Notifier = require './modules/notifier'

Utils = require './utils'
Timer = require './timer'
config = require CONFIG_PATH

class Pomodoremi
  DEFAULT_OPTIONS =
    lengths:
      work: Utils.toMs(25)
      shortBreak: Utils.toMs(5)
      longBreak: Utils.toMs(15)

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    @modules = []
    @modules.push new CommandLineLog
    @modules.push new Notifier

    @timer = new Timer()

    @timer.onStart =>
      @startTime = new Date
      @tags = []
      @modules[0].start(@type, @name, @lengths[@type], ->)

    @timer.onStop =>
      @stopTime = new Date
      @modules[0].stop(@type, ->)

    @timer.onUpdate (passed) =>
      @modules[0].update(@type, passed, ->)

    @timer.onFinish =>
      @modules[0].finish(@type, ->)
      @modules[1].finish(@type, ->)

    @timer.onOverstay (delay) =>
      @modules[1].overstay(@type, delay, ->)

  start: (@name = 'Pomodoro') ->
    @type = 'work'
    @timer.start @lengths[@type]

  shortBreak: ->
    @type = 'shortBreak'
    @timer.start @lengths[@type]

  longBreak: ->
    @type = 'longBreak'
    @timer.start @lengths[@type]

  stop: ->
    @type = undefined
    @timer.stop()

  tag: (tag) ->
    return unless tag?
    @tags.push tag

module.exports = Pomodoremi
