#!/usr/bin/env node
var PORT, Pomodoremi, _, args, bridge, cli, client, command, commands, commandsHelp, dnode, flags, header, maxCommandLength, meow, pkg, pomodoremi, ref, s, subCommands,
  slice = [].slice;

PORT = (ref = process.env.POMODOREMI_PORT) != null ? ref : 7387;

_ = require('lodash');

s = require('underscore.string');

meow = require('meow');

dnode = require('dnode');

pkg = require('../package.json');

Pomodoremi = require('./pomodoremi');

pomodoremi = new Pomodoremi();

cli = meow({
  help: false,
  pkg: pkg
});

subCommands = cli.input.slice(1, cli.input.length);

flags = _.isEmpty(cli.flags) ? [] : cli.flags;

command = cli.input[0];

args = subCommands.concat(flags);

if (command == null) {
  header = "Usage:\n  pomodoremi <command> [args] [options]\n\nCommands:\n";
  commands = _.merge({}, pomodoremi.help, {
    server: function() {
      return ['server', 'starts server'];
    }
  });
  maxCommandLength = _(commands).values().map(function(fn) {
    return fn()[0].length;
  }).max();
  commandsHelp = _(commands).values().map(function(fn) {
    var description, ref1;
    ref1 = fn(), command = ref1[0], description = ref1[1];
    return "  pomodoro " + (s.rpad(command, maxCommandLength)) + "   " + description + "\n";
  });
  console.log(header + commandsHelp.join(''));
} else if (command === 'server') {
  bridge = {
    method: function() {
      var args, cb, i, name;
      name = arguments[0], args = 3 <= arguments.length ? slice.call(arguments, 1, i = arguments.length - 1) : (i = 1, []), cb = arguments[i++];
      return pomodoremi[name].apply(pomodoremi, slice.call(args).concat([cb]));
    }
  };
  dnode(bridge, {
    weak: false
  }).listen(PORT);
} else if (_(pomodoremi).functions().include(command)) {
  client = dnode.connect(PORT);
  client.on('remote', function(remote) {
    return remote.method.apply(remote, [command].concat(slice.call(args), [function(result) {
      if (result != null) {
        console.log(result);
      }
      return client.end();
    }]));
  });
} else {
  console.log("Command '" + command + "' not found");
}
