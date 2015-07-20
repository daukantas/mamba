require_dir = require 'require-dir'
require_dir './gulp/tasks', recurse: true

gulp = require 'gulp'


build_common = [
  'cjsx'
  'sass'
]


gulp.task 'build:development', gulp.series(
  build_common...,
  'bundle:development'
)

gulp.task 'build:production', gulp.series(
  build_common...,
  'bundle:production'
)