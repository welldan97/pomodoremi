var IntervalFactory, Pomodoremi, Timer, Utils, _, fs, setUpConfigs, setUpModules,
  slice = [].slice;

fs = require('fs');

_ = require('lodash');

Utils = require('./utils');

Timer = require('./timer');

IntervalFactory = require('./interval-factory');

setUpConfigs = require('./pomodoremi/set-up-configs');

setUpModules = require('./pomodoremi/set-up-modules');

Pomodoremi = (function() {
  function Pomodoremi(options) {
    var ref;
    if (options == null) {
      options = {};
    }
    this.timer = new Timer();
    setUpConfigs(this, options);
    setUpModules(this, this.modules);
    ref = IntervalFactory(this.durations), this.Work = ref.Work, this.ShortBreak = ref.ShortBreak, this.LongBreak = ref.LongBreak;
  }

  Pomodoremi.prototype.help = {
    start: function() {
      return ['start [name]', 'starts Pomodoro'];
    },
    shortBreak: function() {
      return ['shortBreak', 'starts short break'];
    },
    longBreak: function() {
      return ['longBreak', 'starts long break'];
    },
    stop: function() {
      return ['stop', 'stops Pomodoro or break'];
    }
  };

  Pomodoremi.prototype.start = function() {
    var args, cb, i, interval;
    args = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), cb = arguments[i++];
    interval = new this.Work({
      name: args[0]
    });
    this.timer.start(interval);
    return cb();
  };

  Pomodoremi.prototype.shortBreak = function(cb) {
    var interval;
    interval = new this.ShortBreak;
    this.timer.start(interval);
    return cb();
  };

  Pomodoremi.prototype.longBreak = function(cb) {
    var interval;
    interval = new this.LongBreak;
    this.timer.start(interval);
    return cb();
  };

  Pomodoremi.prototype.stop = function(cb) {
    this.timer.stop();
    return cb();
  };

  return Pomodoremi;

})();

module.exports = Pomodoremi;
