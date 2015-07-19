gulp = require 'gulp'
{SRC} = require '../shared'
react = require 'gulp-react'


gulp.task 'react', ->
  gulp
  .src(SRC.jsx())
  .pipe(react())
  .pipe(gulp.dest(SRC.js()))