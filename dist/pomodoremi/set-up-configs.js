var CommandLineUI, DEFAULT_OPTIONS, Notifier, Tags, Utils, _, setUpConfigs;

_ = require('lodash');

require('coffee-script/register');

Utils = require('../utils');

Tags = require('../modules/tags');

CommandLineUI = require('../modules/command-line-ui');

Notifier = require('../modules/notifier');

DEFAULT_OPTIONS = {
  durations: {
    work: Utils.toMs(25),
    shortBreak: Utils.toMs(5),
    longBreak: Utils.toMs(15)
  },
  modules: [new Tags(), new CommandLineUI(), new Notifier()]
};

setUpConfigs = function(pomodoremi, options) {
  var PERSONAL_CONFIG_PATH, personalConfigLoad, ref;
  PERSONAL_CONFIG_PATH = (ref = process.env.POMODOREMI_CONFIG_PATH) != null ? ref : process.env.HOME + "/.pomodoremi/config";
  _.merge(pomodoremi, DEFAULT_OPTIONS, options);
  personalConfigLoad = Utils.canRequire(PERSONAL_CONFIG_PATH) ? require(PERSONAL_CONFIG_PATH) : (console.log('no personal config'), function() {});
  return personalConfigLoad.apply(pomodoremi);
};

module.exports = setUpConfigs;
