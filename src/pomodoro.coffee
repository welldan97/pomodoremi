CONFIG_PATH = "#{process.env.HOME}/.pomodoro/config"

_ = require 'lodash'
s = require 'underscore.string'
require 'coffee-script/register'

ProgressBar = require 'progress'
notifier = require 'node-notifier'

Utils = require './utils'
Timer = require './timer'
config = require CONFIG_PATH

class Pomodoro
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
      afterBreak: 'Please, go to work'

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    @progressBarOptions = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]
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

    message =  (type) =>
      switch type
        when 'shortBreak'
          @messages['break']
        when 'longBreak'
          @messages['break']
        when 'work'
          @messages['work']
    typeUppercase = s(type).capitalize().value()

    @progressBar = new ProgressBar @progressBarOptions...

    @progressBar.update 0, status: this["#{type}Length"]

    @timer.start Utils.toMs(this["#{type}Length"])

    this["onStart#{typeUppercase}"]()

    @timer.notify (passed) =>
      this["onNotify#{typeUppercase}"](passed)
      passedInMins = this["#{type}Length"] * (passed / Utils.toMs(this["#{type}Length"]))
      status = this["#{type}Length"] - Math.floor(passedInMins)
      @progressBar.update passed / Utils.toMs(this["#{type}Length"]), { status }

    @timer.finish =>
      this["onFinish#{typeUppercase}"]()
      @progressBar.update 1, { status: 0 }
      @progressBar = undefined
      notifier.notify title: '🍅', message: message(type)

    @timer.overstay (delay) =>
      this["onOverstay#{typeUppercase}"](delay)
      overstayInMins = Utils.toMin(delay)
      notifier.notify title: '🍅', message: "Overstayed: #{overstayInMins}"

  resetTimer: ->
    @progressBar.update 1, { status: 0 } if @progressBar
    console.log "  \##{@tags.join(' #')}" unless _.isEmpty @tags
    @tags = []
    if @type?
      @stopTime = new Date
      typeUppercase = s(@type).capitalize().value()
      this["onStop#{typeUppercase}"]()
    @type = null
    @timer.stop()
    @timer = new Timer()
module.exports = Pomodoro
