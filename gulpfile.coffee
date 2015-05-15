gulp = require 'gulp'
coffee = require 'gulp-coffee'
insert = require 'gulp-insert'

runSequence = require 'run-sequence'

gulp.task 'build', ->
  gulp.src(['src/*.coffee', '!./src/cli.coffee'])
    .pipe(coffee(bare: true))
    .pipe gulp.dest('lib')

  gulp.src('src/cli.coffee')
    .pipe(coffee(bare: true))
    .pipe(insert.prepend('#!/usr/bin/env node\n'))
    .pipe gulp.dest('lib')
