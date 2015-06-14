var ONE_MIN_IN_MS, _, async, moment,
  slice = [].slice;

async = require('async');

_ = require('lodash');

ONE_MIN_IN_MS = 60 * 1000;

moment = require('moment');

module.exports = {
  toMs: function(mins) {
    return mins * ONE_MIN_IN_MS;
  },
  toMin: function(ms) {
    return ms / ONE_MIN_IN_MS;
  },
  formatDate: function(date) {
    return moment().format('h:mm:ss a');
  },
  formatMin: function(ms) {
    return Math.floor(this.toMin(ms));
  },
  callAll: function() {
    var args, arr, fn;
    arr = arguments[0], fn = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    return async.eachSeries(arr, function(e, cb) {
      if (_.isFunction(e[fn])) {
        return e[fn].apply(e, slice.call(args).concat([cb]));
      } else {
        return cb();
      }
    });
  }
};
