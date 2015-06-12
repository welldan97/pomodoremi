#!/usr/bin/env node
var Pomodoremi, SimpleRabbit, _, args, cli, flags, meow, pkg, pomodoremi, simpleRabbit, subCommands,
  slice = [].slice;

_ = require('lodash');

meow = require('meow');

pkg = require('../package.json');

SimpleRabbit = require('simple-rabbit');

Pomodoremi = require('./pomodoremi');

simpleRabbit = new SimpleRabbit();

pomodoremi = new Pomodoremi();

cli = meow({
  help: false,
  pkg: pkg
});

subCommands = cli.input.slice(1, cli.input.length);

flags = _.isEmpty(cli.flags) ? [] : cli.flags;

args = subCommands.concat(flags);

if (cli.input[0] === 'server') {
  simpleRabbit.reader(pomodoremi);
} else {
  simpleRabbit.invoke.apply(simpleRabbit, [cli.input[0]].concat(slice.call(args)));
}
