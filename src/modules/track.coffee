class Track
  start: (interval, cb) ->
    interval.startTime = new Date
    cb()

  stop: (interval, cb) ->
    interval.stopTime = new Date
    cb()

module.exports = Track
