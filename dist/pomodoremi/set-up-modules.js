var EVENTS, Utils, _, setUpModules;

_ = require('lodash');

Utils = require('../utils');

EVENTS = ['start', 'stop', 'update', 'finish', 'overstay'];

setUpModules = function(pomodoremi, modules) {
  var commandsList, helpList;
  commandsList = _(modules).pluck('commands').compact().value();
  _.forEach(commandsList, function(commands) {
    return _.merge(pomodoremi, commands);
  });
  helpList = _(modules).pluck('help').compact().value();
  _.forEach(helpList, function(help) {
    return _.merge(pomodoremi.help, help);
  });
  return _.forEach(EVENTS, function(event) {
    return pomodoremi.timer.on(event, function(interval) {
      return Utils.callAll(modules, event, interval);
    });
  });
};

module.exports = setUpModules;
