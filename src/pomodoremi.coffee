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

    @timer.update (passed) =>
      @middlewares[0].update(type, passed, ->)

    @timer.finish =>
      @middlewares[0].finish(type, ->)
      @middlewares[1].finish(type, ->)

    @timer.overstay (delay) =>
      @middlewares[1].overstay(type, delay, ->)

  resetTimer: ->
    @middlewares[0].reset(->)
    @tags = []
    if @type?
      @stopTime = new Date
      typeUppercase = s(@type).capitalize().value()
    @type = null
    @timer.stop()
    @timer = new Timer()

module.exports = Pomodoremi
