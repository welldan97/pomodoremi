_ = require 'lodash'
require 'coffee-script/register'

Utils = require '../utils'
Tags = require '../modules/tags'
CommandLineUI = require '../modules/command-line-ui'
Notifier = require '../modules/notifier'
# Debug = require '../modules/debug'

DEFAULT_OPTIONS =
  durations:
    work: Utils.toMs(25)
    shortBreak: Utils.toMs(5)
    longBreak: Utils.toMs(15)

  modules: [
    new Tags()
    new CommandLineUI()
    new Notifier()
    # new Debug()
  ]

setUpConfigs = (pomodoremi, options) ->
  PERSONAL_CONFIG_PATH = process.env.POMODOREMI_CONFIG_PATH ?
    "#{process.env.HOME}/.pomodoremi/config"

  _.merge(pomodoremi, DEFAULT_OPTIONS, options)

  personalConfigLoad =
    if Utils.canRequire PERSONAL_CONFIG_PATH
      require PERSONAL_CONFIG_PATH
    else
      console.log 'no personal config'
      ->
  personalConfigLoad.apply pomodoremi


module.exports = setUpConfigs
