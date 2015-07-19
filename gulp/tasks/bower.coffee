gulp = require 'gulp'

{DEST, BOWER} = require '../shared'

concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
filter = require 'gulp-filter'
rename = require 'gulp-rename'

concat_CSS = require 'gulp-concat-css'
minify_CSS = require 'gulp-minify-css'


gulp.task 'bower:js', ->
  only_js = filter([
    '*.js'
    '!*.min.js'
  ])

  BOWER.stream(only_js)
    .pipe concat('bower.js')
    .pipe uglify()
    .pipe rename(DEST.BOWER.jsfile())
    .pipe gulp.dest(DEST.BOWER.base())

gulp.task 'bower:css', ->
  onlyCSS = filter([
    '*.css'
  ])

  BOWER.stream(onlyCSS)
    .pipe concat_CSS('bower.css')
    .pipe minify_CSS()
    .pipe rename(DEST.BOWER.cssfile())
    .pipe gulp.dest(DEST.BOWER.base())

gulp.task 'bower', gulp.parallel('bower:js', 'bower:css')