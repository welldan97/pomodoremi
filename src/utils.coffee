async = require 'async'
_ = require 'lodash'

ONE_MIN_IN_MS = 60 * 1000

moment = require 'moment'

module.exports =
  toMs: (mins) -> mins * ONE_MIN_IN_MS
  toMin: (ms) -> ms / ONE_MIN_IN_MS
  formatDate: (date) -> moment().format('h:mm:ss a')
  formatMin: (ms) -> Math.floor(@toMin(ms))
  callAll: (arr, fn, args...) ->
    async.eachSeries arr, (e, cb) ->
      if _.isFunction(e[fn])
        e[fn](args..., cb)
      else
        cb()
