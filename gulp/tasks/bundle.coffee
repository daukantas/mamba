gulp = require 'gulp'
{APP, DST} = require '../shared'

browserify = require 'browserify'
exorcist = require 'exorcist'
minifify = require 'minifyify'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
fs = require 'fs'


MAP_SOURCE_ROOT = '/'


gulp.task 'bundle:production', (done) ->
  browserify(entries: APP.entries(), debug: true)
    .plugin 'minifyify',
      map: DST.srcmap()
      output: DST.srcmap(fullpath: true)
    .bundle (_, minified, srcmap) ->
      # this is necessary to set the correct paths to sources
      # in web inspectors; couldn't find a way to do this
      # through minifyify's API
      srcmap = JSON.parse srcmap
      srcmap.sourceRoot = MAP_SOURCE_ROOT

      fs.writeFile DST.srcmap(fullpath: true), JSON.stringify srcmap
      fs.writeFile DST.bundle(fullpath: true), minified
      done?()


gulp.task 'bundle:development', ->
  browserify(entries: APP.entries(), debug: true)
  .bundle()
  .pipe exorcist(DST.srcmap(fullpath: true), null, MAP_SOURCE_ROOT)
  .pipe source(DST.bundle())
  .pipe buffer()
  .pipe gulp.dest(DST.js())