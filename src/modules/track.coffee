class Track
  start: (interval, cb) ->
    interval.startTime = new Date
    cb()

  stop: (interval, delay, cb) ->
    interval.stopTime = new Date
    cb()

module.exports = Track
