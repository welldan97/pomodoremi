var ONE_MIN_IN_MS, moment;

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
  }
};
