var Progress, ProgressBar, Utils;

Utils = require('../utils');

Progress = require('progress');

ProgressBar = (function() {
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

  function ProgressBar(options) {
    this.options = options != null ? options : DEFAULT_OPTIONS;
  }

  ProgressBar.prototype.start = function(type, length, cb) {
    this.length = length;
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

  ProgressBar.prototype.notify = function(type, passed, cb) {
    var passedInMins, status;
    passedInMins = this.length * (passed / Utils.toMs(this.length));
    status = this.length - Math.floor(passedInMins);
    this.progress.update(passed / Utils.toMs(this.length), {
      status: status
    });
    return cb();
  };

  ProgressBar.prototype.finish = function(type, cb) {
    this.progress.update(1, {
      status: 0
    });
    this.progress = void 0;
    return cb();
  };

  ProgressBar.prototype.reset = function(cb) {
    if (this.progress) {
      this.progress.update(1, {
        status: 0
      });
    }
    return cb();
  };

  return ProgressBar;

})();

module.exports = ProgressBar;
