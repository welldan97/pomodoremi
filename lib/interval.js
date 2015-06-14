var Interval, Utils;

Utils = require('./utils');

Interval = (function() {
  function Interval(type, options) {
    this.type = type;
    if (options) {
      this.name = options['name'];
    }
    this.length = Interval.lengths[this.type];
  }

  return Interval;

})();

module.exports = Interval;
