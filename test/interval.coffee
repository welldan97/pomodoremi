expect =  require('chai').expect
Interval = require '../src/interval'

describe 'Interval', ->
  beforeEach ->
    Interval.lengths = work: 777

  describe '#constructor', ->
    it 'sets length depending on type', ->
      interval = new Interval 'work'
      expect(interval.length).to.equal 777

    it 'sets name', ->
      interval = new Interval 'work', name: 'Black Mirror'
      expect(interval.name).to.equal 'Black Mirror'
