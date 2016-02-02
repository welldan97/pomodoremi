var Interval, Utils;

Utils = require('./utils');

Interval = (function() {
  function Interval(arg) {
    this.type = arg.type, this.name = arg.name, this.duration = arg.duration, this.startedAt = arg.startedAt, this.stoppedAt = arg.stoppedAt;
  }

  Interval.prototype.timePassed = function() {
    return new Date() - this.startedAt;
  };

  Interval.prototype.timeOverstayed = function() {
    return this.timePassed() - this.duration;
  };

  Interval.prototype.isFinished = function() {
    return this.timeOverstayed() >= 0;
  };

  return Interval;

})();

module.exports = Interval;
