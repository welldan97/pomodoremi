_ = require 'lodash'
meow = require 'meow'
pkg = require '../package.json'
SimpleRabbit = require 'simple-rabbit'
Pomodoro = require './pomodoro'

simpleRabbit = new SimpleRabbit()
pomodoro = new Pomodoro()
cli = meow
  help: false
  pkg: pkg

subCommands = cli.input.slice(1, cli.input.length)
flags = if _.isEmpty(cli.flags)
  []
else
  cli.flags

args = subCommands.concat flags

if cli.input[0] == 'server'
  simpleRabbit.reader(pomodoro)
else
  simpleRabbit.invoke cli.input[0], args...
