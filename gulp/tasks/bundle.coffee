gulp = require 'gulp'
{APP, BUILD, DEST} = require '../shared'

minify_css = require 'gulp-minify-css'
concat = require 'gulp-concat'

browserify = require 'browserify'
sourcemaps = require 'gulp-sourcemaps'
exorcist = require 'exorcist'
minifify = require 'minifyify'

rename = require 'gulp-rename'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
fs = require 'fs'


###
  JS bundling tasks
###

SRCMAP_ROOT = '/'

gulp.task 'bundle:js:production', (done) ->
  browserify(entries: BUILD.entries(), debug: true)
    .plugin 'minifyify',
      map: DEST.srcmap()
      output: DEST.srcmap(fullpath: true)
    .bundle (_, minified, srcmap) ->
      # this is necessary to set the correct paths to sources
      # in web inspectors; couldn't find a way to do this
      # through minifyify's API
      srcmap = JSON.parse srcmap
      srcmap.sourceRoot = SRCMAP_ROOT

      fs.writeFile DEST.srcmap(fullpath: true), JSON.stringify srcmap
      fs.writeFile DEST.bundle(fullpath: true), minified
      done?()


gulp.task 'bundle:js:development', ->
  browserify(entries: BUILD.entries(), debug: true)
    .bundle()
    .pipe exorcist(DEST.srcmap(fullpath: true), null, SRCMAP_ROOT)
    .pipe source(DEST.bundle())
    .pipe buffer()
    .pipe gulp.dest(DEST.js())


###
  CSS bundling tasks; no sourcemaps
###

cat_css_stream = ->
  gulp
    .src(BUILD.css())
    .pipe concat(DEST.css_bundle())

gulp.task 'bundle:css:production', ->
  cat_css_stream()
    .pipe minify_css()
    .pipe gulp.dest(DEST.css())

gulp.task 'bundle:css:development', ->
  cat_css_stream()
    .pipe gulp.dest(DEST.css())


gulp.task 'bundle:development',
  gulp.parallel('bundle:js:development', 'bundle:css:development')
gulp.task 'bundle:production',
  gulp.parallel('bundle:js:production', 'bundle:css:production')