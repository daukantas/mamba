gulp = require 'gulp'

inject = require 'gulp-inject'
rename = require 'gulp-rename'

{APP, BOWER, DST} = require '../shared'

gulp.task 'inject:bower', ->
  bower_files = gulp.src [
    DST.BOWER.jsfile(fullpath: true)
    DST.BOWER.cssfile(fullpath: true)
  ], read: false

  gulp
    .src APP.template()
    .pipe inject(bower_files, name: 'bower')
    .pipe gulp.dest(DST.base())


gulp.task 'inject:js', ->
  source_files = gulp.src [
    DST.bundle(fullpath: true)
  ], read: false

  gulp
    .src DST.template()
    .pipe inject(source_files)
    .pipe gulp.dest(DST.base())


gulp.task 'inject', gulp.series('inject:bower', 'inject:js')