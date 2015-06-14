CONFIG_PATH = "#{process.env.HOME}/.pomodoremi/config"

_ = require 'lodash'
s = require 'underscore.string'
require 'coffee-script/register'

# ProgressBar = require 'progress'
ProgressBar = require './middleware/progress-bar'
notifier = require 'node-notifier'

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


    messages:
      afterWork: 'Take a Break, Darling'
      afterShortBreak: 'Please, go to work'
      afterLongBreak: 'Please, go to work'

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    @middlewares = []
    @middlewares.push new ProgressBar
    @timer = new Timer()

  start: (@name = 'Pomodoro') ->
    console.log("(#{Utils.formatDate(new Date)})") unless @type?

    console.log @name
    @resetTimer()
    @startTimer('work')

  stop: ->
    @resetTimer()
    console.log("(#{Utils.formatDate(new Date)})\n") unless @type?

  shortBreak: ->
    @resetTimer()
    console.log '----'
    @startTimer('shortBreak')

  longBreak: ->
    @resetTimer()
    console.log '===='
    @startTimer('longBreak')

  tag: (tag) ->
    return unless tag?
    @tags.push tag

  startTimer: (type) ->
    @type = type
    @startTime = new Date

    typeUppercase = s(type).capitalize().value()

    @middlewares[0].start(type, this["#{type}Length"], ->)

    @timer.start Utils.toMs(this["#{type}Length"])

    this["onStart#{typeUppercase}"]()

    @timer.notify (passed) =>
      this["onNotify#{typeUppercase}"](passed)
      @middlewares[0].notify(type, passed, ->)

    @timer.finish =>
      this["onFinish#{typeUppercase}"]()
      @middlewares[0].finish(type, ->)
      notifier.notify title: '🍅', message: @messages["after#{typeUppercase}"]

    @timer.overstay (delay) =>
      this["onOverstay#{typeUppercase}"](delay)
      overstayInMins = Utils.toMin(delay)
      notifier.notify title: '🍅', message: "Overstayed: #{overstayInMins}"

  resetTimer: ->
    @middlewares[0].reset(->)
    console.log "  \##{@tags.join(' #')}" unless _.isEmpty @tags
    @tags = []
    if @type?
      @stopTime = new Date
      typeUppercase = s(@type).capitalize().value()
      this["onStop#{typeUppercase}"]()
    @type = null
    @timer.stop()
    @timer = new Timer()

module.exports = Pomodoremi
