gulp = require 'gulp'
sass = require 'gulp-sass'

{APP, BUILD} = require '../shared'


gulp.task 'sass', ->
  gulp
    .src "#{APP.base()}/**/*.scss"
    .pipe sass()
    .pipe gulp.dest(BUILD.base())