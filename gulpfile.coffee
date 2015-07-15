gulp = require 'gulp'
react = require 'gulp-react'

browserify = require 'browserify'
exorcist = require 'exorcist'
uglifyjs = require 'uglify-js'

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
  bundle_map = DEST.js('bundle-map.json')
  stream = ''

  browserify(entries: DEST.js('grid.js'), debug: true)
    .bundle()
    .pipe(exorcist(bundle_map))
    .on 'data', (chunk) ->
      stream += chunk
    .on 'end', ->
      minified = uglifyjs.minify stream,
        fromString: true
        inSourceMap: bundle_map
        outSourceMap: 'bundle-min.map'
        sourceRoot: 'public/js'

      fs.writeFile DEST.js('bundle-min.js'), minified.code
      fs.writeFile DEST.js('bundle-min.map'), JSON.stringify(JSON.parse minified.map)


gulp.task 'build', gulp.series('react', 'bundle')