expect =  require('chai').expect

setUpConfigs = require '../../src/pomodoremi/set-up-configs'

pomodoremi = undefined

describe 'setUpConfigs', ->
  beforeEach ->
    process.env.POMODOREMI_CONFIG_PATH = 'nope'
    pomodoremi = {}

  it 'sets default options', ->
    setUpConfigs(pomodoremi)

    expect(pomodoremi.durations).to.exist

  it 'sets passed options', ->
    setUpConfigs(pomodoremi, { passed: true })

    expect(pomodoremi.passed).to.exist

  it 'applies personal config', ->
    process.env.POMODOREMI_CONFIG_PATH = "#{process.cwd()}/test/fixtures/config"

    setUpConfigs(pomodoremi)

    expect(pomodoremi.durations.work).to.equal 777
