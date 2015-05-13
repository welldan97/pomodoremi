_ = require 'lodash'
ProgressBar = require 'progress'
notifier = require 'node-notifier'

Utils = require './utils'
Timer = require './timer'

class Pomodoro
  DEFAULT_OPTIONS =
    workLength: 25
    shortBreakLength: 5
    longBreakLength: 15

    messages:
      afterWork: 'Take a Break, Darling'
      afterBreak: 'Please, go to work'

  constructor: (options = DEFAULT_OPTIONS) ->
    _.merge(this, DEFAULT_OPTIONS, options)
    @timer = new Timer()
    @progressBarOptions = [':bar :status',
      clear: true
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  start: (name = 'Pomodoro') ->
    console.log new Date
    console.log name
    @_setTimer('work')

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

    @progressBar = new ProgressBar @progressBarOptions...

    @progressBar.update 0, status: 0

    @timer.start Utils.toMs(this["#{type}Length"])

    @timer.notify (passed) =>
      passedInMins = this["#{type}Length"] * (passed / Utils.toMs(this["#{type}Length"]))
      status = this["#{type}Length"] - Math.floor(passedInMins)
      @progressBar.update passed / Utils.toMs(this["#{type}Length"]), { status }

    @timer.finish =>
      @progressBar.update 1, { status: 0 }
      console.log '\n'
      notifier.notify title: '🍅', message: message(type)

    @timer.overstay (d) ->
      overstayInMins = Utils.toMin(d)
      console.log "Overstayed: #{overstayInMins}"
      notifier.notify title: '🍅', message: "Overstayed: #{overstayInMins}"

module.exports = Pomodoro
