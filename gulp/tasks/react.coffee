gulp = require 'gulp'
{APP} = require '../shared'
react = require 'gulp-react'


gulp.task 'react', ->
  gulp
  .src APP.jsx()
  .pipe react()
  .pipe gulp.dest(APP.base())