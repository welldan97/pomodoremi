expect =  require('chai').expect
sinon = require 'sinon'

Interval = require '../src/interval'
clock = undefined

describe 'Interval', ->
  beforeEach ->
    Interval.lengths = work: 777
    clock = sinon.useFakeTimers()

  describe '#constructor', ->
    it 'sets length depending on type', ->
      interval = new Interval 'work'
      expect(interval.length).to.equal 777

    it 'sets name', ->
      interval = new Interval 'work', name: 'Black Mirror'
      expect(interval.name).to.equal 'Black Mirror'

  describe '#start', ->
    it 'sets startedAt', ->
      interval = new Interval 'work'
      interval.start()
      expect(interval.startedAt.getTime()).to.equal (new Date).getTime()

  describe '#stop', ->
    it 'sets stoppedAt', ->
      interval = new Interval 'work'
      interval.stop()
      expect(interval.stoppedAt.getTime()).to.equal (new Date).getTime()

  describe '#timePassed', ->
    it 'counts time passed', ->
      interval = new Interval 'work'
      interval.start()
      clock.tick 100
      expect(interval.timePassed()).to.equal 100
