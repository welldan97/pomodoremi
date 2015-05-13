SimpleRabbit = require './simple_rabbit'
simpleRabbit = new SimpleRabbit()

class Router
  constructor: ->

  server: ->
    simpleRabbit.read (data) ->
  start: ->
    simpleRabbit.write({hi: 'there'})

module.exports = Router
