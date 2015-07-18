gulp = require 'gulp'
path = require 'path'
react = require 'gulp-react'

browserify = require 'browserify'
exorcist = require 'exorcist'
minifify = require 'minifyify'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'

fs = require 'fs'


path_suffix = (suffix) ->
  (suffix && ('/' + suffix )) || ''


SRC =
  _base: ->
    'src'

  entries: ->
    [@js('grid.js')]

  jsx: ->
    "#{@_base()}/jsx/**.jsx"

  js: (suffix) ->
    "#{@_base()}/js#{path_suffix(suffix)}"


PUBLIC =
  _base: ->
    'public'

  js: (suffix) ->
    "#{@_base()}/js#{path_suffix(suffix)}"

  _js_file: (file, options) ->
    if options.fullpath
      file = @js(file)
    file

  srcmap: (options = {fullpath: false}) ->
    @_js_file('mamba.js.map', options)

  bundle: (options = {fullpath: false}) ->
    @_js_file('mamba.js', options)


gulp.task 'react', ->
  gulp
  .src(SRC.jsx())
  .pipe(react())
  .pipe(gulp.dest(SRC.js()))


gulp.task 'bundle:production', (done) ->
  browserify(entries: SRC.entries(), debug: true)
    .plugin 'minifyify',
      map: PUBLIC.srcmap()
      output: PUBLIC.srcmap(fullpath: true)
    .bundle (_, minified, map) ->
      # this is necessary to set the correct paths to sources
      # in web inspectors; couldn't find a way to do this through minifyify.
      map = JSON.parse map
      map.sourceRoot = '/'

      fs.writeFile PUBLIC.srcmap(fullpath: true), JSON.stringify map
      fs.writeFile PUBLIC.bundle(fullpath: true), minified
      done?()


gulp.task 'bundle:development', ->
  browserify(entries: SRC.entries(), debug: true)
    .bundle()
    .pipe exorcist(PUBLIC.srcmap(fullpath: true), null, '/')
    .pipe source(PUBLIC.bundle())
    .pipe buffer()
    .pipe gulp.dest(PUBLIC.js())


gulp.task 'build:development', gulp.series(
  'react',
  'bundle:development'
)
gulp.task 'build:production', gulp.series(
  'react',
  'bundle:production'
)