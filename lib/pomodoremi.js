var CONFIG_PATH, CommandLineUI, Interval, Notifier, Pomodoremi, Tags, Timer, Track, Utils, _, config, fs,
  slice = [].slice;

CONFIG_PATH = process.env.HOME + "/.pomodoremi/config";

fs = require('fs');

_ = require('lodash');

require('coffee-script/register');

Tags = require('./modules/tags');

Track = require('./modules/track');

CommandLineUI = require('./modules/command-line-ui');

Notifier = require('./modules/notifier');

Utils = require('./utils');

Timer = require('./timer');

Interval = require('./interval');

config = Utils.canRequire(CONFIG_PATH) ? require(CONFIG_PATH) : function() {};

Pomodoremi = (function() {
  var DEFAULT_OPTIONS;

  DEFAULT_OPTIONS = {
    help: {
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
    },
    lengths: {
      work: Utils.toMs(25),
      shortBreak: Utils.toMs(5),
      longBreak: Utils.toMs(15)
    },
    modules: [new Track, new Tags, new CommandLineUI, new Notifier]
  };

  function Pomodoremi(options) {
    var commandsList, helpList;
    if (options == null) {
      options = {};
    }
    _.merge(this, DEFAULT_OPTIONS, options);
    config.apply(this);
    _.merge(Interval, {
      lengths: this.lengths
    });
    this.timer = new Timer();
    commandsList = _(this.modules).pluck('commands').compact().value();
    _.forEach(commandsList, (function(_this) {
      return function(commands) {
        return _.merge(_this, commands);
      };
    })(this));
    helpList = _(this.modules).pluck('help').compact().value();
    _.forEach(helpList, (function(_this) {
      return function(help) {
        return _.merge(_this.help, help);
      };
    })(this));
    _.forEach(['start', 'stop', 'update', 'finish', 'overstay'], (function(_this) {
      return function(event) {
        return _this.timer.on(event, function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return Utils.callAll.apply(Utils, [_this.modules, event, _this.interval].concat(slice.call(args)));
        });
      };
    })(this));
  }

  Pomodoremi.prototype.start = function() {
    var args, cb, i, name, ref;
    args = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), cb = arguments[i++];
    name = (ref = args[0]) != null ? ref : 'Pomodoro';
    this.interval = new Interval('work', {
      name: name
    });
    this.timer.start(this.interval);
    return cb();
  };

  Pomodoremi.prototype.shortBreak = function(cb) {
    this.interval = new Interval('shortBreak');
    this.timer.start(this.interval);
    return cb();
  };

  Pomodoremi.prototype.longBreak = function(cb) {
    this.interval = new Interval('longBreak');
    this.timer.start(this.interval);
    return cb();
  };

  Pomodoremi.prototype.stop = function(cb) {
    this.timer.stop();
    return cb();
  };

  return Pomodoremi;

})();

module.exports = Pomodoremi;
