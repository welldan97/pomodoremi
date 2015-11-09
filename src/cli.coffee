PORT = process.env.POMODOREMI_PORT ? 7387

_ = require 'lodash'
s = require 'underscore.string'
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

command = cli.input[0]
args = subCommands.concat flags

if !command?
  header =
  """
    Usage:
      pomodoremi <command> [args] [options]

    Commands:

  """
  commands = _.merge({}, pomodoremi.help, server: -> ['server', 'starts server'])
  maxCommandLength = _(commands)
    .values()
    .map (fn) -> fn()[0].length
    .max()
  commandsHelp = _(commands).values().map (fn) ->
    [command, description] = fn()
    "  pomodoro #{s.rpad(command, maxCommandLength)}   #{description}\n"

  console.log header + commandsHelp.join('')

else if command == 'server'
  bridge = method:
    (name, args..., cb) ->
      pomodoremi[name](args..., cb)
  dnode(bridge, weak: false).listen PORT
else if _(pomodoremi).functions().include(command)
  client = dnode.connect(PORT)
  client.on 'remote', (remote) ->
    remote.method command, args..., (result) ->
      console.log result if result?
      client.end()
else
  console.log "Command '#{command}' not found"
