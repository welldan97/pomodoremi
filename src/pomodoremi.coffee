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
    workLength: 25
    shortBreakLength: 5
    longBreakLength: 15

    onStartWork: ->
    onNotifyWork: ->
    onFinishWork: ->
    onOverstayWork: ->
    onStopWork: ->

    onStartShortBreak: ->
    onNotifyShortBreak: ->
    onFinishShortBreak: ->
    onOverstayShortBreak: ->
    onStopShortBreak: ->

    onStartLongBreak: ->
    onNotifyLongBreak: ->
    onFinishLongBreak: ->
    onOverstayLongBreak: ->
    onStopLongBreak: ->

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    @middlewares = []
    @middlewares.push new CommandLineLog
    @middlewares.push new Notifier
    @timer = new Timer()

  start: (@name = 'Pomodoro') ->
    @resetTimer()
    @startTimer('work')

  stop: ->
    @resetTimer()
    console.log("(#{Utils.formatDate(new Date)})\n") unless @type?

  shortBreak: ->
    @resetTimer()
    @startTimer('shortBreak')

  longBreak: ->
    @resetTimer()
    @startTimer('longBreak')

  tag: (tag) ->
    return unless tag?
    @tags.push tag

  startTimer: (type, name) ->
    @type = type
    @startTime = new Date

    typeUppercase = s(type).capitalize().value()

    @middlewares[0].start(type, @name, this["#{type}Length"], ->)

    @timer.start Utils.toMs(this["#{type}Length"])

    this["onStart#{typeUppercase}"]()

    @timer.notify (passed) =>
      this["onNotify#{typeUppercase}"](passed)
      @middlewares[0].notify(type, passed, ->)

    @timer.finish =>
      this["onFinish#{typeUppercase}"]()
      @middlewares[0].finish(type, ->)
      @middlewares[1].finish(type, ->)

    @timer.overstay (delay) =>
      this["onOverstay#{typeUppercase}"](delay)
      @middlewares[1].overstay(type, delay, ->)

  resetTimer: ->
    @middlewares[0].reset(->)
    @tags = []
    if @type?
      @stopTime = new Date
      typeUppercase = s(@type).capitalize().value()
      this["onStop#{typeUppercase}"]()
    @type = null
    @timer.stop()
    @timer = new Timer()

module.exports = Pomodoremi
