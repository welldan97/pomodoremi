var Timer, Utils;

Utils = require('./utils');

Timer = (function() {
  var ONE_MINUTE;

  ONE_MINUTE = Utils.toMs(1);

  function Timer(delay) {
    this.delay = delay != null ? delay : ONE_MINUTE;
  }

  Timer.prototype.start = function(length) {
    this.length = length;
    this.processed = 0;
    this.started = true;
    return setTimeout(((function(_this) {
      return function() {
        return _this.process();
      };
    })(this)), this.delay);
  };

  Timer.prototype.stop = function() {
    return this.started = false;
  };

  Timer.prototype.process = function() {
    if (!this.started) {
      return;
    }
    this.processed += 1;
    if ((this.processed - 1) * this.delay >= this.length) {
      if (typeof this.onOverstay === "function") {
        this.onOverstay(this.processed * this.delay - this.length);
      }
    } else if (this.processed * this.delay >= this.length) {
      if (typeof this.onFinish === "function") {
        this.onFinish();
      }
    } else {
      if (typeof this.onNotify === "function") {
        this.onNotify(this.processed * this.delay);
      }
    }
    return setTimeout(((function(_this) {
      return function() {
        return _this.process();
      };
    })(this)), this.delay);
  };

  Timer.prototype.notify = function(onNotify) {
    this.onNotify = onNotify;
  };

  Timer.prototype.overstay = function(onOverstay) {
    this.onOverstay = onOverstay;
  };

  Timer.prototype.finish = function(onFinish) {
    this.onFinish = onFinish;
  };

  return Timer;

})();

module.exports = Timer;
