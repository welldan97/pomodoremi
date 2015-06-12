var CONFIG_PATH, Pomodoro, ProgressBar, Timer, Utils, _, config, notifier, s;

CONFIG_PATH = process.env.HOME + "/.pomodoro/config";

_ = require('lodash');

s = require('underscore.string');

require('coffee-script/register');

ProgressBar = require('progress');

notifier = require('node-notifier');

Utils = require('./utils');

Timer = require('./timer');

config = require(CONFIG_PATH);

Pomodoro = (function() {
  var DEFAULT_OPTIONS;

  DEFAULT_OPTIONS = {
    workLength: 25,
    shortBreakLength: 5,
    longBreakLength: 15,
    onStartWork: function() {},
    onNotifyWork: function() {},
    onFinishWork: function() {},
    onOverstayWork: function() {},
    onStopWork: function() {},
    onStartShortBreak: function() {},
    onNotifyShortBreak: function() {},
    onFinishShortBreak: function() {},
    onOverstayShortBreak: function() {},
    onStopShortBreak: function() {},
    onStartLongBreak: function() {},
    onNotifyLongBreak: function() {},
    onFinishLongBreak: function() {},
    onOverstayLongBreak: function() {},
    onStopLongBreak: function() {},
    messages: {
      afterWork: 'Take a Break, Darling',
      afterShortBreak: 'Please, go to work',
      afterLongBreak: 'Please, go to work'
    }
  };

  function Pomodoro(options) {
    if (options == null) {
      options = {};
    }
    _.merge(this, DEFAULT_OPTIONS, config, options);
    this.progressBarOptions = [
      ':bar :status', {
        clear: true,
        complete: "█",
        incomplete: "░",
        width: 25,
        total: 100
      }
    ];
    this.timer = new Timer();
  }

  Pomodoro.prototype.start = function(name) {
    this.name = name != null ? name : 'Pomodoro';
    if (this.type == null) {
      console.log("(" + (Utils.formatDate(new Date)) + ")");
    }
    console.log(this.name);
    this.resetTimer();
    return this.startTimer('work');
  };

  Pomodoro.prototype.stop = function() {
    this.resetTimer();
    if (this.type == null) {
      return console.log("(" + (Utils.formatDate(new Date)) + ")\n");
    }
  };

  Pomodoro.prototype.shortBreak = function() {
    this.resetTimer();
    console.log('----');
    return this.startTimer('shortBreak');
  };

  Pomodoro.prototype.longBreak = function() {
    this.resetTimer();
    console.log('====');
    return this.startTimer('longBreak');
  };

  Pomodoro.prototype.tag = function(tag) {
    if (tag == null) {
      return;
    }
    return this.tags.push(tag);
  };

  Pomodoro.prototype.startTimer = function(type) {
    var typeUppercase;
    this.type = type;
    this.startTime = new Date;
    typeUppercase = s(type).capitalize().value();
    this.progressBar = (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(ProgressBar, this.progressBarOptions, function(){});
    this.progressBar.update(0, {
      status: this[type + "Length"]
    });
    this.timer.start(Utils.toMs(this[type + "Length"]));
    this["onStart" + typeUppercase]();
    this.timer.notify((function(_this) {
      return function(passed) {
        var passedInMins, status;
        _this["onNotify" + typeUppercase](passed);
        passedInMins = _this[type + "Length"] * (passed / Utils.toMs(_this[type + "Length"]));
        status = _this[type + "Length"] - Math.floor(passedInMins);
        return _this.progressBar.update(passed / Utils.toMs(_this[type + "Length"]), {
          status: status
        });
      };
    })(this));
    this.timer.finish((function(_this) {
      return function() {
        _this["onFinish" + typeUppercase]();
        _this.progressBar.update(1, {
          status: 0
        });
        _this.progressBar = void 0;
        return notifier.notify({
          title: '🍅',
          message: _this.messages["after" + typeUppercase]
        });
      };
    })(this));
    return this.timer.overstay((function(_this) {
      return function(delay) {
        var overstayInMins;
        _this["onOverstay" + typeUppercase](delay);
        overstayInMins = Utils.toMin(delay);
        return notifier.notify({
          title: '🍅',
          message: "Overstayed: " + overstayInMins
        });
      };
    })(this));
  };

  Pomodoro.prototype.resetTimer = function() {
    var typeUppercase;
    if (this.progressBar) {
      this.progressBar.update(1, {
        status: 0
      });
    }
    if (!_.isEmpty(this.tags)) {
      console.log("  \#" + (this.tags.join(' #')));
    }
    this.tags = [];
    if (this.type != null) {
      this.stopTime = new Date;
      typeUppercase = s(this.type).capitalize().value();
      this["onStop" + typeUppercase]();
    }
    this.type = null;
    this.timer.stop();
    return this.timer = new Timer();
  };

  return Pomodoro;

})();

module.exports = Pomodoro;
