var Interval, _,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

_ = require('lodash');

Interval = require('./interval');

module.exports = function(arg) {
  var LongBreak, ShortBreak, Work, longBreak, shortBreak, work;
  work = arg.work, shortBreak = arg.shortBreak, longBreak = arg.longBreak;
  Work = (function(superClass) {
    var DEFAULT_OPTIONS;

    extend(Work, superClass);

    DEFAULT_OPTIONS = {
      type: 'work',
      duration: work,
      name: 'Pomodoro'
    };

    function Work(options) {
      Work.__super__.constructor.call(this, _.merge({}, DEFAULT_OPTIONS, options));
    }

    return Work;

  })(Interval);
  ShortBreak = (function(superClass) {
    var DEFAULT_OPTIONS;

    extend(ShortBreak, superClass);

    DEFAULT_OPTIONS = {
      type: 'shortBreak',
      duration: shortBreak
    };

    function ShortBreak(options) {
      ShortBreak.__super__.constructor.call(this, _.merge({}, DEFAULT_OPTIONS, options));
    }

    return ShortBreak;

  })(Interval);
  LongBreak = (function(superClass) {
    var DEFAULT_OPTIONS;

    extend(LongBreak, superClass);

    DEFAULT_OPTIONS = {
      type: 'longBreak',
      duration: longBreak
    };

    function LongBreak(options) {
      LongBreak.__super__.constructor.call(this, _.merge({}, DEFAULT_OPTIONS, options));
    }

    return LongBreak;

  })(Interval);
  return {
    Work: Work,
    ShortBreak: ShortBreak,
    LongBreak: LongBreak
  };
};
