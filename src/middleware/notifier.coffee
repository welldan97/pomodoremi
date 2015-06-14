Utils = require '../utils'
nodeNotifier = require 'node-notifier'

class Notifier
  DEFAULT_OPTIONS =
    work: 'Take a Break, Darling'
    shortBreak: 'Please, go to work'
    longBreak: 'Please, go to work'

  constructor: (@options = DEFAULT_OPTIONS) ->

  finish: (type, cb) ->
    nodeNotifier.notify title: '🍅', message: @options[type]
    cb()

  overstay: (type, delay, cb) ->
    overstayInMins = Utils.toMin(delay)
    nodeNotifier.notify title: '🍅', message: "Overstayed: #{overstayInMins}"
    cb()

module.exports = Notifier
