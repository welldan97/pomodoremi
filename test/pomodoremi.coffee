expect =  require('chai').expect

Pomodoremi = require '../src/pomodoremi'

pomodoremi = undefined
describe 'Pomodoremi', ->
  beforeEach ->
    process.env.POMODOREMI_CONFIG_PATH = 'nope'
    pomodoremi = new Pomodoremi passed: true

  describe '#constructor', ->
