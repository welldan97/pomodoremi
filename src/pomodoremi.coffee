CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
s = require 'underscore.string'
require 'coffee-script/register'

CommandLineLog = require './middleware/command-line-log'
Notifier = require './middleware/notifier'

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
    @middlewares = []
    @middlewares.push new CommandLineLog
    @middlewares.push new Notifier

    @timer = new Timer()

    @timer.onUpdate (passed) =>
      @middlewares[0].update(@type, passed, ->)

    @timer.onFinish =>
      @middlewares[0].finish(@type, ->)
      @middlewares[1].finish(@type, ->)

    @timer.onOverstay (delay) =>
      @middlewares[1].overstay(@type, delay, ->)

  start: (@name = 'Pomodoro') ->
    @_startTimer('work')

  stop: ->
    @_stopTimer()

  shortBreak: ->
    @_startTimer('shortBreak')

  longBreak: ->
    @_startTimer('longBreak')

  tag: (tag) ->
    return unless tag?
    @tags.push tag

  _startTimer: (type, name) ->
    @_stopTimer()
    @type = type
    @startTime = new Date

    @middlewares[0].start(type, @name, @lengths[type], ->)

    @timer.start @lengths[type]

  _stopTimer: ->
    @middlewares[0].stop(@type, ->)
    @tags = []
    if @type?
      @stopTime = new Date
    @type = null
    @timer.stop()

module.exports = Pomodoremi
