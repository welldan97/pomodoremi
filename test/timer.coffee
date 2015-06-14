expect =  require('chai').expect
sinon = require('sinon')

clock = undefined

beforeEach ->
  clock = sinon.useFakeTimers()

afterEach ->
  clock.restore()


describe 'Timer', ->
  it 'fix me', ->
    timedOut = false
    setTimeout (-> timedOut = true), 500

    expect(timedOut).to.be.false
    clock.tick 510
    expect(timedOut).to.be.true
