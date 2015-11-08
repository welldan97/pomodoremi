expect =  require('chai').expect
sinon = require 'sinon'

Timer = require '../src/timer'
Interval = require '../src/interval'

clock = undefined
timer = undefined
interval = undefined

describe 'Timer', ->
  beforeEach ->
    timer = new Timer(10)
    clock = sinon.useFakeTimers()

    Interval.lengths = work: 100
    interval = new Interval('work')

  afterEach ->
    clock.restore()

  describe '#start', ->
    it 'starts the timer', ->
      expect(timer.startedAt).to.not.exist
      timer.start(interval)
      expect(timer.startedAt).to.exist

    it 'starts processing', ->
      timer.start(interval)
      expect(timer.processed).to.equal 0
      clock.tick 10
      expect(timer.processed).to.equal 1

    it 'notifies', ->
      times = 0
      timer.on 'start', ->
        times += 1
      expect(times).to.equal 0
      timer.start(interval)
      expect(times).to.equal 1

    it 'notifies onStop if double started', ->
      times = 0
      timer.on 'stop', ->
        times += 1
      timer.start(interval)
      expect(times).to.equal 0
      timer.start(interval)
      expect(times).to.equal 1

  describe '#process', ->
    beforeEach ->
      timer.start(interval)

    it 'notifies on update', ->
      times = 0
      timer.on 'update', ->
        times += 1
      expect(times).to.equal 0
      clock.tick 10
      expect(times).to.equal 1
      clock.tick 200
      expect(times).to.equal 9

    it 'notifies on finish', ->
      times = 0
      timer.on 'finish', ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 1

    it 'notifies on overstay', ->
      times = 0
      timer.on 'overstay', ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 10

    it 'not notifies if stopped', ->
      times = 0
      timer.on 'update', ->
        times += 1
      expect(times).to.equal 0
      clock.tick 15
      timer.stop()
      clock.tick 200
      expect(times).to.equal 1

    it 'not double notifies if stopped and started again', ->
      times = 0
      timer.on 'update', ->
        times += 1

      expect(times).to.equal 0
      clock.tick 5
      timer.stop()
      clock.tick 3
      timer.start(interval)
      clock.tick 25
      expect(times).to.equal 2
      timer.stop()
      clock.tick 3
      timer.start(interval)
      clock.tick 200
      expect(times).to.equal 11

  describe '#stop', ->
    beforeEach ->
      timer.start(interval)

    it 'stop processing', ->
      expect(timer.startedAt).to.exist
      timer.stop()
      expect(timer.startedAt).to.not.exist

    it 'notifies', ->
      times = 0
      timer.on 'stop', ->
        times += 1
      expect(times).to.equal 0
      timer.stop()
      expect(times).to.equal 1

    it 'notifies only when started', ->
      times = 0
      timer.on 'stop', ->
        times += 1
      expect(times).to.equal 0
      timer.stop()
      timer.stop()
      expect(times).to.equal 1
