expect =  require('chai').expect
sinon = require 'sinon'

Interval = require '../src/interval'
clock = undefined

describe 'Interval', ->
  beforeEach ->
    clock = sinon.useFakeTimers()

  describe '#constructor', ->
    it 'sets length depending on type', ->
      interval = new Interval 'work', length: 777
      expect(interval.length).to.equal 777

    it 'sets name', ->
      interval = new Interval 'work', name: 'Black Mirror', length: 777
      expect(interval.name).to.equal 'Black Mirror'

  describe '#timePassed', ->
    it 'counts time passed', ->
      interval = new Interval 'work', length: 777
      interval.startedAt = new Date
      clock.tick 100
      expect(interval.timePassed()).to.equal 100

  describe '#timeOverstayed', ->
    it 'counts time overstayed', ->
      interval = new Interval 'work', length: 777
      interval.startedAt = new Date
      clock.tick 100
      expect(interval.timeOverstayed()).to.equal -677

      clock.tick 677
      expect(interval.timeOverstayed()).to.equal 0

      clock.tick 1
      expect(interval.timeOverstayed()).to.equal 1

  describe '#isFinished', ->
    it 'returns true if it is already finished', ->
      interval = new Interval 'work', length: 777
      interval.startedAt = new Date
      clock.tick 100
      expect(interval.isFinished()).to.equal false

      clock.tick 677
      expect(interval.isFinished()).to.equal true

      clock.tick 1
      expect(interval.isFinished()).to.equal true
