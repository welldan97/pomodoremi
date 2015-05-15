#!/usr/bin/env node
var Pomodoro, SimpleRabbit, _, args, cli, flags, meow, pkg, pomodoro, simpleRabbit, subCommands,
  slice = [].slice;

_ = require('lodash');

meow = require('meow');

pkg = require('../package.json');

SimpleRabbit = require('./simple_rabbit');

Pomodoro = require('./pomodoro');

simpleRabbit = new SimpleRabbit();

pomodoro = new Pomodoro();

cli = meow({
  help: false,
  pkg: pkg
});

subCommands = cli.input.slice(1, cli.input.length);

flags = _.isEmpty(cli.flags) ? [] : cli.flags;

args = subCommands.concat(flags);

if (cli.input[0] === 'server') {
  simpleRabbit.reader(pomodoro);
} else {
  simpleRabbit.invoke.apply(simpleRabbit, [cli.input[0]].concat(slice.call(args)));
}
