gulp = require 'gulp'

inject = require 'gulp-inject'
rename = require 'gulp-rename'

{APP, BOWER, DEST} = require '../shared'


strip_base = (filepath) ->
  filepath.replace("/#{DEST.base()}/", '')

inject_script = (filepath) ->
  "<script src='#{strip_base(filepath)}'></script>"

inject_css = (filepath) ->
  "<link rel='stylesheet' href='#{strip_base(filepath)}'>"


gulp.task 'inject:bower', ->
  bower_files = gulp.src [
    DEST.bower.jsfile(fullpath: true)
    DEST.bower.cssfile(fullpath: true)
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


gulp.task 'inject:css', ->
  source_css = gulp.src DEST.css_bundle(), read: false

  gulp
    .src DEST.template()
    .pipe inject(source_css, transform: inject_css)
    .pipe gulp.dest(DEST.base())


# This can't be done in parallel because of race conditions!
gulp.task 'inject', gulp.series('inject:bower', 'inject:js', 'inject:css')
