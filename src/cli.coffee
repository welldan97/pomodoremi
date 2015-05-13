meow = require 'meow'
pkg = require '../package.json'

Pomodoro = require './pomodoro'

cli = meow
  help: false
  pkg: pkg

pomodoro = new Pomodoro()

subCommand = cli.input[1] ? 2

if subCommand
  pomodoro[cli.input[0]](subCommand, cli.flags)
else
  pomodoro[cli.input[0]](cli.flags)
