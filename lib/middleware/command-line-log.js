var CommandLineLog, Progress, Utils;

Utils = require('../utils');

Progress = require('progress');

CommandLineLog = (function() {
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

  function CommandLineLog(options) {
    this.options = options != null ? options : DEFAULT_OPTIONS;
  }

  CommandLineLog.prototype.start = function(type, name, length, cb) {
    this.length = length;
    switch (type) {
      case 'work':
        console.log(name);
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
      status: this.length
    });
    return cb();
  };

  CommandLineLog.prototype.notify = function(type, passed, cb) {
    var passedInMins, status;
    passedInMins = this.length * (passed / Utils.toMs(this.length));
    status = this.length - Math.floor(passedInMins);
    this.progress.update(passed / Utils.toMs(this.length), {
      status: status
    });
    return cb();
  };

  CommandLineLog.prototype.finish = function(type, cb) {
    this.progress.update(1, {
      status: 0
    });
    this.progress = void 0;
    return cb();
  };

  CommandLineLog.prototype.reset = function(cb) {
    if (this.progress) {
      this.progress.update(1, {
        status: 0
      });
    }
    return cb();
  };

  return CommandLineLog;

})();

module.exports = CommandLineLog;
