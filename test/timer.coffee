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
      expect(timer.started).not.to.be
      timer.start(100)
      expect(timer.started).to.be

    it 'starts processing', ->
      timer.start(100)
      expect(timer.processed).to.equal 0
      clock.tick 10
      expect(timer.processed).to.equal 1

  describe '#process', ->
    beforeEach ->
      timer.start(100)

    it 'notifies on update', ->
      times = 0
      timer.update ->
        times += 1
      expect(times).to.equal 0
      clock.tick 10
      expect(times).to.equal 1
      clock.tick 200
      expect(times).to.equal 9

    it 'notifies on finish', ->
      times = 0
      timer.finish ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 1

    it 'notifies on overstay', ->
      times = 0
      timer.overstay ->
        times += 1
      expect(times).to.equal 0
      clock.tick 200
      expect(times).to.equal 10

    it 'not notifies if stopped', ->
      times = 0
      timer.update ->
        times += 1
      expect(times).to.equal 0
      clock.tick 15
      timer.stop()
      clock.tick 200
      expect(times).to.equal 1

  describe '#stop', ->
    beforeEach ->
      timer.start(100)

    it 'stop processing', ->
      expect(timer.started).to.be
      timer.stop()
      expect(timer.processed).not.to.be
