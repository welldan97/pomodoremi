_ = require 'lodash'

Utils = require '../utils'

EVENTS = ['start', 'stop', 'update', 'finish', 'overstay']

setUpModules =
  (pomodoremi, modules) ->
    commandsList = _(modules).pluck('commands').compact().value()
    _.forEach commandsList, (commands) ->
      _.merge(pomodoremi, commands)

    helpList = _(modules).pluck('help').compact().value()
    _.forEach helpList, (help) ->
      _.merge(pomodoremi.help, help)

    _.forEach EVENTS, (event) ->
      pomodoremi.timer.on event, (interval) ->
        Utils.callAll modules, event, interval

module.exports = setUpModules
