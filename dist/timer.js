var EventEmitter, Timer, Utils;

EventEmitter = require('events').EventEmitter;

Utils = require('./utils');

Timer = (function() {
  var DEFAULT_PERIOD;

  DEFAULT_PERIOD = Utils.toMs(1);

  function Timer(period) {
    this.period = period != null ? period : DEFAULT_PERIOD;
    this.on = EventEmitter.prototype.on;
    this.emit = EventEmitter.prototype.emit;
  }

  Timer.prototype.start = function(interval) {
    this.finishEmitted = false;
    this.processed = 0;
    this.stop();
    this.interval = interval;
    this.interval.startedAt = new Date();
    this.emit('start', this.interval);
    return this._schedule(interval);
  };

  Timer.prototype.stop = function() {
    if (this.interval == null) {
      return;
    }
    this.interval.stoppedAt = new Date();
    this.emit('stop', this.interval);
    return this.interval = void 0;
  };

  Timer.prototype.process = function(interval) {
    if (this.interval == null) {
      return;
    }
    if (this.interval !== interval) {
      return;
    }
    this.processed += 1;
    if (!this.interval.isFinished()) {
      this.emit('update', this.interval);
    } else if (!this.finishEmitted) {
      this.emit('finish', this.interval);
      this.finishEmitted = true;
    } else {
      this.emit('overstay', this.interval);
    }
    return this._schedule(interval);
  };

  Timer.prototype._schedule = function(interval) {
    return setTimeout(((function(_this) {
      return function() {
        return _this.process(interval);
      };
    })(this)), this.period);
  };

  return Timer;

})();

module.exports = Timer;
