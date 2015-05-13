meow = require 'meow'
pkg = require '../package.json'
SimpleRabbit = require './simple_rabbit'
Pomodoro = require './pomodoro'

simpleRabbit = new SimpleRabbit()
pomodoro = new Pomodoro()
cli = meow
  help: false
  pkg: pkg

subCommand = cli.input[1] ? 2

args = if subCommand
  [subCommand, cli.flags]
else
  [cli.flags]

if cli.input[0] == 'server'
  simpleRabbit.reader(pomodoro)
else
  simpleRabbit.write(method: cli.input[0], args: args)
