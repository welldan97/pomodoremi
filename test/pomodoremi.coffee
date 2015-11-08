expect =  require('chai').expect

process.env.POMODOREMI_CONFIG_PATH = 'nope'

Pomodoremi = require '../src/pomodoremi'

pomodoremi = undefined
describe 'Pomodoremi', ->
  beforeEach ->
    pomodoremi = new Pomodoremi passed: true

  describe '#constructor', ->
    it 'should set default options', ->
      expect(pomodoremi.durations).to.exist

    it 'should set passed options', ->
      expect(pomodoremi.passed).to.exist
