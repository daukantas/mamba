gulp = require 'gulp'

inject = require 'gulp-inject'
rename = require 'gulp-rename'

{APP, BOWER, DEST} = require '../shared'


inject_script = (filepath) ->
  path = filepath.replace("/#{DEST.base()}/", '')
  "<script src=#{path}></script>"


gulp.task 'inject:bower', ->
  bower_files = gulp.src [
    DEST.BOWER.jsfile(fullpath: true)
    DEST.BOWER.cssfile(fullpath: true)
  ], read: false

  gulp
    .src APP.template()
    .pipe inject(bower_files,
      name: 'bower'
      transform: inject_script)
    .pipe gulp.dest(DEST.base())


gulp.task 'inject:js', ->
  source_files = gulp.src [
    DEST.bundle(fullpath: true)
  ], read: false

  gulp
    .src DEST.template()
    .pipe inject(source_files, transform: inject_script)
    .pipe gulp.dest(DEST.base())


gulp.task 'inject', gulp.series('inject:bower', 'inject:js')