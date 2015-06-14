var CONFIG_PATH, CommandLineUI, Interval, Notifier, Pomodoremi, Tags, Timer, Track, Utils, _, config,
  slice = [].slice;

CONFIG_PATH = process.env.HOME + "/.pomodoremi/config";

_ = require('lodash');

require('coffee-script/register');

Tags = require('./modules/tags');

Track = require('./modules/track');

CommandLineUI = require('./modules/command-line-ui');

Notifier = require('./modules/notifier');

Utils = require('./utils');

Timer = require('./timer');

Interval = require('./interval');

config = require(CONFIG_PATH);

Pomodoremi = (function() {
  var DEFAULT_OPTIONS;

  DEFAULT_OPTIONS = {
    lengths: {
      work: Utils.toMs(25),
      shortBreak: Utils.toMs(5),
      longBreak: Utils.toMs(15)
    },
    modules: [new Track, new Tags, new CommandLineUI, new Notifier]
  };

  function Pomodoremi(options) {
    var commandsList;
    if (options == null) {
      options = {};
    }
    _.merge(this, DEFAULT_OPTIONS, config, options);
    _.merge(Interval, {
      lengths: this.lengths
    });
    commandsList = _(this.modules).pluck('commands').compact().value();
    _.forEach(commandsList, (function(_this) {
      return function(commands) {
        return _.merge(_this, commands);
      };
    })(this));
    this.timer = new Timer();
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

  Pomodoremi.prototype.start = function(name) {
    if (name == null) {
      name = 'Pomodoro';
    }
    this.interval = new Interval('work', {
      name: name
    });
    return this.timer.start(this.interval);
  };

  Pomodoremi.prototype.shortBreak = function() {
    this.interval = new Interval('shortBreak');
    return this.timer.start(this.interval);
  };

  Pomodoremi.prototype.longBreak = function() {
    this.interval = new Interval('longBreak');
    return this.timer.start(this.interval);
  };

  Pomodoremi.prototype.stop = function() {
    return this.timer.stop();
  };

  return Pomodoremi;

})();

module.exports = Pomodoremi;
