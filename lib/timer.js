var EventEmitter, Timer, Utils;

EventEmitter = require('events').EventEmitter;

Utils = require('./utils');

Timer = (function() {
  var ONE_MINUTE;

  ONE_MINUTE = Utils.toMs(1);

  function Timer(delay) {
    this.delay = delay != null ? delay : ONE_MINUTE;
    this.on = EventEmitter.prototype.on;
    this.emit = EventEmitter.prototype.emit;
  }

  Timer.prototype.start = function(interval) {
    this.length = interval.length;
    if (this.startedAt) {
      this.emit('stop', this.processed * this.delay);
    }
    this.processed = 0;
    this.startedAt = new Date();
    this.emit('start');
    return this._schedule(this.startedAt);
  };

  Timer.prototype.stop = function() {
    if (this.startedAt) {
      this.emit('stop', this.processed * this.delay);
    }
    return this.startedAt = void 0;
  };

  Timer.prototype.process = function(startedAt) {
    if (!this.startedAt) {
      return;
    }
    if (this.startedAt !== startedAt) {
      return;
    }
    this.processed += 1;
    if ((this.processed - 1) * this.delay >= this.length) {
      this.emit('overstay', this.processed * this.delay - this.length);
    } else if (this.processed * this.delay >= this.length) {
      this.emit('finish');
    } else {
      this.emit('update', this.processed * this.delay);
    }
    return this._schedule(startedAt);
  };

  Timer.prototype._schedule = function(startedAt) {
    return setTimeout(((function(_this) {
      return function() {
        return _this.process(startedAt);
      };
    })(this)), this.delay);
  };

  return Timer;

})();

module.exports = Timer;
