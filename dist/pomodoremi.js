var IntervalFactory, Pomodoremi, Timer, Utils, _, fs, setUpConfigs,
  slice = [].slice;

fs = require('fs');

_ = require('lodash');

Utils = require('./utils');

Timer = require('./timer');

IntervalFactory = require('./interval-factory');

setUpConfigs = require('./pomodoremi/set-up-configs');

console.log('hhhh');

Pomodoremi = (function() {
  var EVENTS;

  EVENTS = ['start', 'stop', 'update', 'finish', 'overstay'];

  function Pomodoremi(options) {
    var ref;
    if (options == null) {
      options = {};
    }
    this.timer = new Timer();
    setUpConfigs(this, options);
    this._loadModules(this.modules);
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

  Pomodoremi.prototype._loadModules = function(modules) {
    var commandsList, helpList;
    commandsList = _(modules).pluck('commands').compact().value();
    _.forEach(commandsList, (function(_this) {
      return function(commands) {
        return _.merge(_this, commands);
      };
    })(this));
    helpList = _(modules).pluck('help').compact().value();
    _.forEach(helpList, (function(_this) {
      return function(help) {
        return _.merge(_this.help, help);
      };
    })(this));
    return _.forEach(EVENTS, (function(_this) {
      return function(event) {
        return _this.timer.on(event, function(interval) {
          return Utils.callAll(modules, event, interval);
        });
      };
    })(this));
  };

  return Pomodoremi;

})();

module.exports = Pomodoremi;
