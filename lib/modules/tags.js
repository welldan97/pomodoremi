var Tags, _;

_ = require('lodash');

Tags = (function() {
  function Tags() {}

  Tags.prototype.help = {
    tag: function() {
      return ['tag <tag>', 'add tag'];
    },
    tags: function() {
      return ['tags', 'list tags'];
    }
  };

  Tags.prototype.commands = {
    tag: function(tag, cb) {
      if (tag == null) {
        return;
      }
      this.interval.tags.push(tag);
      return cb();
    },
    tags: function(cb) {
      if (_.isEmpty(this.interval.tags)) {
        return cb('no tags');
      } else {
        return cb("\#" + (this.interval.tags.join(' #')));
      }
    }
  };

  Tags.prototype.start = function(interval, cb) {
    interval.tags = [];
    return cb();
  };

  return Tags;

})();

module.exports = Tags;
