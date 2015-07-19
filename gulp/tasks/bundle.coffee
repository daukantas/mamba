gulp = require 'gulp'
{SRC, DST} = require '../shared'

browserify = require 'browserify'
exorcist = require 'exorcist'
minifify = require 'minifyify'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
fs = require 'fs'


map_source_root = '/'


gulp.task 'bundle:production', (done) ->
  browserify(entries: SRC.entries(), debug: true)
  .plugin 'minifyify',
    map: DST.srcmap()
    output: DST.srcmap(fullpath: true)
  .bundle (_, minified, map) ->
    # this is necessary to set the correct paths to sources
    # in web inspectors; couldn't find a way to do this
    # through minifyify's API
    map = JSON.parse map
    map.sourceRoot = map_source_root

    fs.writeFile DST.srcmap(fullpath: true), JSON.stringify map
    fs.writeFile DST.bundle(fullpath: true), minified
    done?()


gulp.task 'bundle:development', ->
  browserify(entries: SRC.entries(), debug: true)
  .bundle()
  .pipe exorcist(DST.srcmap(fullpath: true), null, map_source_root)
  .pipe source(DST.bundle())
  .pipe buffer()
  .pipe gulp.dest(DST.js())