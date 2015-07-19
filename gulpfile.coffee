require_dir = require 'require-dir'
require_dir './gulp/tasks', recurse: true

gulp = require 'gulp'



gulp.task 'build:development', gulp.series(
  'react',
  'bundle:development'
)

gulp.task 'build:production', gulp.series(
  'react',
  'bundle:production'
)