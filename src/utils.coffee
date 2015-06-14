ONE_MIN_IN_MS = 60 * 1000
ONE_MIN_IN_MS = 300

moment = require 'moment'

module.exports =
  toMs: (mins) -> mins * ONE_MIN_IN_MS
  toMin: (ms) -> ms / ONE_MIN_IN_MS
  formatDate: (date) -> moment().format('h:mm:ss a')
  formatMin: (ms) -> Math.floor(@toMin(ms))
