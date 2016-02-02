expect =  require('chai').expect

Pomodoremi = require '../src/pomodoremi'

pomodoremi = undefined
describe 'Pomodoremi', ->
  beforeEach ->
    process.env.POMODOREMI_CONFIG_PATH = 'nope'
    pomodoremi = new Pomodoremi passed: true

  describe '#constructor', ->
    it 'should set default options', ->
      expect(pomodoremi.durations).to.exist

    it 'should set passed options', ->
      expect(pomodoremi.passed).to.exist
