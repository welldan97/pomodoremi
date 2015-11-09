var Debug, _,
  slice = [].slice;

_ = require('lodash');

Debug = (function() {
  function Debug() {
    _.forEach(['start', 'stop', 'update', 'finish', 'overstay'], (function(_this) {
      return function(event) {
        return _this[event] = function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return console.log.apply(console, [event].concat(slice.call(args)));
        };
      };
    })(this));
  }

  return Debug;

})();

module.exports = Debug;
