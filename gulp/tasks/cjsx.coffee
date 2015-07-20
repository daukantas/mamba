gulp = require 'gulp'
cjsx = require 'gulp-cjsx'
gutil = require 'gulp-util'


{APP, BUILD} = require '../shared'


gulp.task 'cjsx', ->
  gulp
    .src APP.cjsx()
    .pipe cjsx(bare: true)
      .on 'error', gutil.log
    .pipe gulp.dest BUILD.base()
