_ = require 'lodash'
meow = require 'meow'
pkg = require '../package.json'
SimpleRabbit = require 'simple-rabbit'
Pomodoremi = require './pomodoremi'

simpleRabbit = new SimpleRabbit()
pomodoremi = new Pomodoremi()
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
  simpleRabbit.reader(pomodoremi)
else
  simpleRabbit.invoke cli.input[0], args...
