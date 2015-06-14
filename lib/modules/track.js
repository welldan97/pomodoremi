var Track;

Track = (function() {
  function Track() {}

  Track.prototype.start = function(interval, cb) {
    interval.startTime = new Date;
    return cb();
  };

  Track.prototype.stop = function(interval, delay, cb) {
    interval.stopTime = new Date;
    return cb();
  };

  return Track;

})();

module.exports = Track;
