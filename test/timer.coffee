expect =  require('chai').expect
sinon = require 'sinon'

Timer = require '../src/timer'

clock = undefined
timer = undefined

describe 'Timer', ->
  beforeEach ->
    timer = new Timer(10)
    clock = sinon.useFakeTimers()

  afterEach ->
    clock.restore()

  describe '#start', ->
    it 'starts the timer', ->
      expect(timer.startedAt).to.not.exist
      timer.start(100)
      expect(timer.startedAt).to.exist

    it 'starts processing', ->
      timer.start(100)
      expect(timer.processed).to.equal 0
      clock.tick 10
      expect(timer.processed).to.equal 1

    it 'notifies', ->
      times = 0
      timer.onStart ->
        times += 1
      expect(times).to.equal 0
      timer.start(100)
      expect(times).to.equal 1

    it 'notifies onStop if double started', ->
      times = 0
      timer.onStop ->
        times += 1
      timer.start(100)
      expect(times).to.equal 0
      timer.start(100)
      expect(times).to.equal 1

  describe '#process', ->
    beforeEach ->
      timer.start(100)

    it 'notifies on update', ->
      times = 0
      timer.onUpdate ->
        times += 1
      expect(times).to.equal 0
      clock.tick 10
      expect(times).to.equal 1
      clock.tick 200
      expect(times).to.equal 9

    it 'notifies on finish', ->
      times = 0
      timer.onFinish ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 1

    it 'notifies on overstay', ->
      times = 0
      timer.onOverstay ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 10

    it 'not notifies if stopped', ->
      times = 0
      timer.onUpdate ->
        times += 1
      expect(times).to.equal 0
      clock.tick 15
      timer.stop()
      clock.tick 200
      expect(times).to.equal 1

    it 'not double notifies if stopped and started again', ->
      times = 0
      timer.onUpdate ->
        times += 1

      expect(times).to.equal 0
      clock.tick 5
      timer.stop()
      clock.tick 3
      timer.start(100)
      clock.tick 25
      expect(times).to.equal 2
      timer.stop()
      clock.tick 3
      timer.start(100)
      clock.tick 200
      expect(times).to.equal 11

  describe '#stop', ->
    beforeEach ->
      timer.start(100)

    it 'stop processing', ->
      expect(timer.startedAt).to.exist
      timer.stop()
      expect(timer.startedAt).to.not.exist

    it 'notifies', ->
      times = 0
      timer.onStop ->
        times += 1
      expect(times).to.equal 0
      timer.stop()
      expect(times).to.equal 1
