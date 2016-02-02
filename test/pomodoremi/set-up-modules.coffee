expect =  require('chai').expect

setUpModules = require '../../src/pomodoremi/set-up-modules'

modules = []
pomodoremi = undefined

describe 'setUpModules', ->
  beforeEach ->
    pomodoremi =
      help: {}
      timer: on: (event, fn) ->
        this[event] = fn

    module1 =
      help:
        testHelp1: ->

      commands:
        testCommand1: ->

      stop: (interval, cb) ->
        interval.module1 = true
        cb()

    module2 =
      help:
        testHelp2: ->

      commands:
        testCommand2: ->

      stop: (interval, cb) ->
        interval.module2 = true
        cb()

    modules = [module1, module2]

  it 'sets up commands', ->
    setUpModules(pomodoremi, modules)

    expect(pomodoremi.testCommand1).to.exist
    expect(pomodoremi.testCommand2).to.exist

  it 'sets up help for commands', ->
    setUpModules(pomodoremi, modules)

    expect(pomodoremi.help.testHelp1).to.exist
    expect(pomodoremi.help.testHelp2).to.exist

  it 'sets up events', (done)->
    interval = {}
    setUpModules(pomodoremi, modules)
    pomodoremi.timer.stop interval

    asyncTest = ->
      expect(interval.module1).to.exist
      expect(interval.module2).to.exist
      done()
    setTimeout asyncTest, 500
