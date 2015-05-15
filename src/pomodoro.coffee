CONFIG_PATH = "#{process.env.HOME}/.pomodoro/config.coffee"

_ = require 'lodash'
s = require 'underscore.string'

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
    onStartShortBreak: ->
    onNotifyShortBreak: ->
    onFinishShortBreak: ->
    onOverstayShortBreak: ->
    onStartLongBreak: ->
    onNotifyLongBreak: ->
    onFinishLongBreak: ->
    onOverstayLongBreak: ->
    onStop: ->

    messages:
      afterWork: 'Take a Break, Darling'
      afterBreak: 'Please, go to work'

  constructor: (options = {}) ->
    _.merge(this, DEFAULT_OPTIONS, config, options)
    @timer = new Timer()
    @progressBarOptions = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  start: (name = 'Pomodoro') ->
    @name = name
    console.log new Date
    console.log name
    @_setTimer('work')

  stop: ->
    @timer.stop()
    console.log new Date

  shortBreak: ->
    @_setTimer('shortBreak')

  longBreak: ->
    @_setTimer('longBreak')

  _setTimer: (type) ->
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
      console.log '\n'
      notifier.notify title: '🍅', message: message(type)

    @timer.overstay (delay) =>
      this["onOverstay#{typeUppercase}"](delay)
      overstayInMins = Utils.toMin(delay)
      console.log "Overstayed: #{overstayInMins}"
      notifier.notify title: '🍅', message: "Overstayed: #{overstayInMins}"

module.exports = Pomodoro
