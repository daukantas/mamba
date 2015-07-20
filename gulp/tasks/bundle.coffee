gulp = require 'gulp'
{APP, BUILD, DEST} = require '../shared'

browserify = require 'browserify'
exorcist = require 'exorcist'
minifify = require 'minifyify'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
fs = require 'fs'


MAP_SOURCE_ROOT = '/'


gulp.task 'bundle:production', (done) ->
  browserify(entries: BUILD.entries(), debug: true)
    .plugin 'minifyify',
      map: DEST.srcmap()
      output: DEST.srcmap(fullpath: true)
    .bundle (_, minified, srcmap) ->
      # this is necessary to set the correct paths to sources
      # in web inspectors; couldn't find a way to do this
      # through minifyify's API
      srcmap = JSON.parse srcmap
      srcmap.sourceRoot = MAP_SOURCE_ROOT

      fs.writeFile DEST.srcmap(fullpath: true), JSON.stringify srcmap
      fs.writeFile DEST.bundle(fullpath: true), minified
      done?()


gulp.task 'bundle:development', ->
  browserify(entries: BUILD.entries(), debug: true)
    .bundle()
    .pipe exorcist(DEST.srcmap(fullpath: true), null, MAP_SOURCE_ROOT)
    .pipe source(DEST.bundle())
    .pipe buffer()
    .pipe gulp.dest(DEST.js())