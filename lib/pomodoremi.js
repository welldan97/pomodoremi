var CONFIG_PATH, Pomodoremi, ProgressBar, Timer, Utils, _, config, notifier, s;

CONFIG_PATH = process.env.HOME + "/.pomodoremi/config";

_ = require('lodash');

s = require('underscore.string');

require('coffee-script/register');

ProgressBar = require('./middleware/progress-bar');

notifier = require('node-notifier');

Utils = require('./utils');

Timer = require('./timer');

config = require(CONFIG_PATH);

Pomodoremi = (function() {
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

  function Pomodoremi(options) {
    if (options == null) {
      options = {};
    }
    _.merge(this, DEFAULT_OPTIONS, config, options);
    this.middlewares = [];
    this.middlewares.push(new ProgressBar);
    this.timer = new Timer();
  }

  Pomodoremi.prototype.start = function(name) {
    this.name = name != null ? name : 'Pomodoro';
    if (this.type == null) {
      console.log("(" + (Utils.formatDate(new Date)) + ")");
    }
    console.log(this.name);
    this.resetTimer();
    return this.startTimer('work');
  };

  Pomodoremi.prototype.stop = function() {
    this.resetTimer();
    if (this.type == null) {
      return console.log("(" + (Utils.formatDate(new Date)) + ")\n");
    }
  };

  Pomodoremi.prototype.shortBreak = function() {
    this.resetTimer();
    console.log('----');
    return this.startTimer('shortBreak');
  };

  Pomodoremi.prototype.longBreak = function() {
    this.resetTimer();
    console.log('====');
    return this.startTimer('longBreak');
  };

  Pomodoremi.prototype.tag = function(tag) {
    if (tag == null) {
      return;
    }
    return this.tags.push(tag);
  };

  Pomodoremi.prototype.startTimer = function(type) {
    var typeUppercase;
    this.type = type;
    this.startTime = new Date;
    typeUppercase = s(type).capitalize().value();
    this.middlewares[0].start(type, this[type + "Length"], function() {});
    this.timer.start(Utils.toMs(this[type + "Length"]));
    this["onStart" + typeUppercase]();
    this.timer.notify((function(_this) {
      return function(passed) {
        _this["onNotify" + typeUppercase](passed);
        return _this.middlewares[0].notify(type, passed, function() {});
      };
    })(this));
    this.timer.finish((function(_this) {
      return function() {
        _this["onFinish" + typeUppercase]();
        _this.middlewares[0].finish(type, function() {});
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

  Pomodoremi.prototype.resetTimer = function() {
    var typeUppercase;
    this.middlewares[0].reset(function() {});
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

  return Pomodoremi;

})();

module.exports = Pomodoremi;
