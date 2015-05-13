Utils = require './utils'
Timer = require './timer'
ProgressBar = require 'progress'

class Pomodoro
  DEFAULT_OPTIONS =
    workLength: 25
    shortBreakLength: 5
    longBreakLength: 15

  constructor: ({ @workLength, @shortBreak, @longBreak } = DEFAULT_OPTIONS) ->
    @timer = new Timer()
    @progressBarOptions = [':bar :status',
      complete: "█"
      incomplete: "░"
      width: 25
      total: 100
    ]

  start: (name = 'Pomodoro', args...) ->
    @progressBar = new ProgressBar @progressBarOptions...

    console.log new Date
    console.log name

    @timer.start Utils.toMs(@workLength)
    console.log @workLength

    @timer.notify (passed) =>
      passedInMins = @workLength * (passed / Utils.toMs(@workLength))
      status = @workLength - Math.floor(passedInMins)
      @progressBar.update passed / Utils.toMs(@workLength), { status }

    @timer.finish (d) =>
      @progressBar.update 1, status: 0
      console.log new Date
      console.log '\n'

    @timer.overstay (d) ->
      console.log "Overstay: #{Utils.toMin(d)}"

module.exports = Pomodoro
