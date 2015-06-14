var Tags;

Tags = (function() {
  function Tags() {}

  Tags.prototype.commands = {
    tag: function(tag) {
      if (tag == null) {
        return;
      }
      return this.interval.tags.push(tag);
    }
  };

  Tags.prototype.start = function(interval, cb) {
    interval.tags = [];
    return cb();
  };

  return Tags;

})();

module.exports = Tags;
