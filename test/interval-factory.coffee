expect =  require('chai').expect

IntervalFactory = require '../src/interval-factory'

Work = undefined
ShortBreak = undefined
LongBreak = undefined
describe 'IntervalFactory', ->
  beforeEach ->
    intervalFactory = IntervalFactory
      work: 666
      shortBreak: 777
      longBreak: 888
    { Work, ShortBreak, LongBreak } = intervalFactory

  describe '#Work', ->
    work = undefined

    beforeEach ->
      work = new Work(startedAt: new Date())

    it 'should be an ancessor of interval', ->
      expect(work.timePassed).to.exist
      expect(work.startedAt).to.exist

    it 'should have type "work"', ->
      expect(work.type).to.equal 'work'

    it 'should have proper duration', ->
      expect(work.duration).to.equal 666

    it 'should have default name', ->
      expect(work.name).to.equal 'Pomodoro'

    it 'should be possible to change name', ->
      work = new Work(name: 'Black Mirror')
      expect(work.name).to.equal 'Black Mirror'

  describe '#ShortBreak', ->
    shortBreak = undefined

    beforeEach ->
      shortBreak = new ShortBreak(startedAt: new Date())

    it 'should be an ancessor of interval', ->
      expect(shortBreak.timePassed).to.exist
      expect(shortBreak.startedAt).to.exist

    it 'should have type "shortBreak"', ->
      expect(shortBreak.type).to.equal 'shortBreak'

    it 'should have proper duration', ->
      expect(shortBreak.duration).to.equal 777

  describe '#LongBreak', ->
    shortBreak = undefined

    beforeEach ->
      shortBreak = new ShortBreak(startedAt: new Date())

    it 'should be an ancessor of interval', ->
      expect(shortBreak.timePassed).to.exist
      expect(shortBreak.startedAt).to.exist

    it 'should have type "shortBreak"', ->
      expect(shortBreak.type).to.equal 'shortBreak'

    it 'should have proper duration', ->
      expect(shortBreak.duration).to.equal 777
