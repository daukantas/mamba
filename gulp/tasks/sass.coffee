gulp = require 'gulp'
sass = require 'gulp-sass'

{APP} = require '../shared'


gulp.task 'sass', ->
  gulp
    .src "#{APP.base()}/**/*.scss"
    .pipe sass()
    .pipe gulp.dest(APP.base())