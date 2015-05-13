meow = require 'meow'
pkg = require '../package.json'

Router = require './router'

cli = meow
  help: false
  pkg: pkg

router = new Router()

subCommand = cli.input[1] ? 2

if subCommand
  router[cli.input[0]](subCommand, cli.flags)
else
  router[cli.input[0]](cli.flags)
