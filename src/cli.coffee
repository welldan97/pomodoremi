PORT = 7387

_ = require 'lodash'
meow = require 'meow'
dnode = require 'dnode'

pkg = require '../package.json'
Pomodoremi = require './pomodoremi'

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
  bridge = method:
    (name, args..., cb) ->
      pomodoremi[name](args..., cb)
  dnode(bridge).listen PORT
else
  name = cli.input[0]
  client = dnode.connect(PORT)
  client.on 'remote', (remote) ->
    remote.method(name, args..., ->)
    client.end()
