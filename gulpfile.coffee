require_dir = require 'require-dir'
require_dir './gulp/tasks', recurse: true

gulp = require 'gulp'


build_common = [
  'clean'
  'cjsx'
  'sass'
  'bower'
]


gulp.task 'build:development', gulp.series(
  build_common...,
  'bundle:development',
  'inject'
)

gulp.task 'build:production', gulp.series(
  build_common...,
  'bundle:production',
  'inject'
)