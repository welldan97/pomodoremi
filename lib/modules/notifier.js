var Notifier, Utils, nodeNotifier;

Utils = require('../utils');

nodeNotifier = require('node-notifier');

Notifier = (function() {
  var DEFAULT_OPTIONS;

  DEFAULT_OPTIONS = {
    work: 'Take a Break, Darling',
    shortBreak: 'Please, go to work',
    longBreak: 'Please, go to work'
  };

  function Notifier(options) {
    this.options = options != null ? options : DEFAULT_OPTIONS;
  }

  Notifier.prototype.finish = function(interval, cb) {
    nodeNotifier.notify({
      title: '🍅',
      message: this.options[interval.type]
    });
    return cb();
  };

  Notifier.prototype.overstay = function(interval, delay, cb) {
    var overstayInMins;
    overstayInMins = Utils.toMin(delay);
    nodeNotifier.notify({
      title: '🍅',
      message: "Overstayed: " + overstayInMins
    });
    return cb();
  };

  return Notifier;

})();

module.exports = Notifier;
