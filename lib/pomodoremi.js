var CommandLineUI, IntervalFactory, Notifier, Pomodoremi, Tags, Timer, Utils, _, fs,
  slice = [].slice;

fs = require('fs');

_ = require('lodash');

require('coffee-script/register');

Tags = require('./modules/tags');

CommandLineUI = require('./modules/command-line-ui');

Notifier = require('./modules/notifier');

Utils = require('./utils');

Timer = require('./timer');

IntervalFactory = require('./interval-factory');

Pomodoremi = (function() {
  var DEFAULT_OPTIONS, EVENTS, PERSONAL_CONFIG_PATH, ref;

  PERSONAL_CONFIG_PATH = (ref = process.env.POMODOREMI_CONFIG_PATH) != null ? ref : process.env.HOME + "/.pomodoremi/config";

  EVENTS = ['start', 'stop', 'update', 'finish', 'overstay'];

  DEFAULT_OPTIONS = {
    durations: {
      work: Utils.toMs(25),
      shortBreak: Utils.toMs(5),
      longBreak: Utils.toMs(15)
    },
    modules: [new Tags, new CommandLineUI, new Notifier]
  };

  function Pomodoremi(options) {
    var ref1;
    if (options == null) {
      options = {};
    }
    this.timer = new Timer();
    this._applyConfig(options);
    this._loadModules(this.modules);
    ref1 = IntervalFactory(this.durations), this.Work = ref1.Work, this.ShortBreak = ref1.ShortBreak, this.LongBreak = ref1.LongBreak;
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

  Pomodoremi.prototype._applyConfig = function(options) {
    var personalConfigLoad;
    if (options == null) {
      options = {};
    }
    _.merge(this, DEFAULT_OPTIONS, options);
    personalConfigLoad = Utils.canRequire(PERSONAL_CONFIG_PATH) ? require(PERSONAL_CONFIG_PATH) : (console.log('no personal config'), function() {});
    return personalConfigLoad.apply(this);
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
