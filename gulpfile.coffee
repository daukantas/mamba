gulp = require 'gulp'
react = require 'gulp-react'

browserify = require 'browserify'
sourcemaps = require 'gulp-sourcemaps'

uglify = require 'gulp-uglify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'


DEST =
  _make_suffix: (pattern) ->
    (pattern && ('/' + pattern )) || ''

  base: ->
    'public'

  js: (pattern) ->
    "#{@base()}/js#{@_make_suffix(pattern)}"

  jsx: (pattern) ->
    "#{@base()}/jsx#{@_make_suffix(pattern)}"


gulp.task 'react', ->
  gulp
  .src(DEST.jsx('/**.jsx'))
  .pipe(react())
  .pipe(gulp.dest(DEST.js()))


gulp.task 'bundle', ->
  browserify(entries: DEST.js('grid.js'), debug: true)
    .bundle()
    .pipe(source('mamba.min.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init(loadMaps: true))
      .pipe(uglify())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(DEST.js()))


gulp.task 'build', gulp.series('react', 'bundle')