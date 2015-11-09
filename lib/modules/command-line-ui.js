var CommandLineUI, Progress, Utils, _;

_ = require('lodash');

Utils = require('../utils');

Progress = require('progress');

CommandLineUI = (function() {
  var DEFAULT_OPTIONS;

  DEFAULT_OPTIONS = [
    ':bar :status', {
      clear: true,
      complete: "█",
      incomplete: "░",
      width: 25,
      total: 100
    }
  ];

  function CommandLineUI(options) {
    this.options = options != null ? options : DEFAULT_OPTIONS;
    this.isSessionStarted = false;
    this.isSessionClosing = false;
  }

  CommandLineUI.prototype.start = function(interval, cb) {
    if (!this.isSessionStarted) {
      console.log("(" + (Utils.formatDate(new Date)) + ")");
    }
    this.isSessionStarted = true;
    this.isSessionClosing = false;
    switch (interval.type) {
      case 'work':
        console.log(interval.name);
        break;
      case 'shortBreak':
        console.log('----');
        break;
      case 'longBreak':
        console.log('====');
    }
    this.progress = (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(Progress, this.options, function(){});
    this.progress.update(0, {
      status: Utils.formatMin(interval.duration)
    });
    return cb();
  };

  CommandLineUI.prototype.update = function(interval, cb) {
    var status;
    status = Utils.formatMin(interval.duration - interval.timePassed());
    this.progress.update(interval.timePassed() / interval.duration, {
      status: status
    });
    return cb();
  };

  CommandLineUI.prototype.finish = function(interval, cb) {
    this.progress.update(1, {
      status: 0
    });
    this.progress = void 0;
    return cb();
  };

  CommandLineUI.prototype.stop = function(interval, cb) {
    this.isSessionClosing = true;
    if (this.progress) {
      this.progress.update(1, {
        status: 0
      });
    }
    if (!_.isEmpty(interval.tags)) {
      console.log("  \#" + (interval.tags.join(' #')));
    }
    setTimeout(((function(_this) {
      return function() {
        return _this._closeSession();
      };
    })(this)), 10000);
    return cb();
  };

  CommandLineUI.prototype._closeSession = function() {
    if (this.isSessionClosing) {
      this.isSessionClosing = false;
      this.isSessionStarted = false;
      return console.log("(" + (Utils.formatDate(new Date)) + ")\n");
    }
  };

  return CommandLineUI;

})();

module.exports = CommandLineUI;
