expect =  require('chai').expect
sinon = require 'sinon'

Interval = require '../src/interval'
clock = undefined
interval = undefined

describe 'Interval', ->
  beforeEach ->
    clock = sinon.useFakeTimers()
    interval = new Interval duration: 777

  afterEach ->
    clock.restore()
  describe '#timePassed', ->
    it 'counts time passed', ->
      interval.startedAt = new Date()
      clock.tick 100
      expect(interval.timePassed()).to.equal 100

  describe '#timeOverstayed', ->
    it 'counts time overstayed', ->
      interval.startedAt = new Date()
      clock.tick 100
      expect(interval.timeOverstayed()).to.equal -677

      clock.tick 677
      expect(interval.timeOverstayed()).to.equal 0

      clock.tick 1
      expect(interval.timeOverstayed()).to.equal 1

  describe '#isFinished', ->
    it 'returns true if it is already finished', ->
      interval.startedAt = new Date()
      clock.tick 100
      expect(interval.isFinished()).to.equal false

      clock.tick 677
      expect(interval.isFinished()).to.equal true

      clock.tick 1
      expect(interval.isFinished()).to.equal true
