gulp = require 'gulp'
react = require 'gulp-react'

browserify = require 'browserify'
exorcist = require 'exorcist'
minifify = require 'minifyify'

fs = require 'fs'


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


gulp.task 'bundle', (done) ->
  browserify(entries: DEST.js('grid.js'), debug: true)
    .plugin 'minifyify',
      map: 'bundle-min.js.map'
      output: 'public/js/bundle-min.js.map'
    .bundle (err, src) ->
      fs.writeFile DEST.js('bundle-min.js'), src
      done?()


gulp.task 'build', gulp.series('react', 'bundle')