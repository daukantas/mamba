gulp = require 'gulp'

{DST} = require '../shared'

bower_files = require 'main-bower-files'

concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
filter = require 'gulp-filter'
rename = require 'gulp-rename'

concat_CSS = require 'gulp-concat-css'
minify_CSS = require 'gulp-minify-css'


BOWER =

  source: bower_files()

  dest: ->
    'public/bower'

  stream: (filter) ->
    gulp
      .src @source
      .pipe filter


gulp.task 'bower:js', ->
  only_js = filter([
    '*.js'
    '!*.min.js'
  ])

  BOWER.stream(only_js)
    .pipe concat('bower.js')
    .pipe uglify()
    .pipe rename('bower.min.js')
    .pipe gulp.dest(BOWER.dest())

gulp.task 'bower:css', ->
  onlyCSS = filter([
    '*.css'
  ])

  BOWER.stream(onlyCSS)
    .pipe concat_CSS('bower.css')
    .pipe minify_CSS()
    .pipe rename('bower.min.css')
    .pipe gulp.dest(BOWER.dest())

gulp.task 'bower', gulp.parallel('bower:js', 'bower:css')