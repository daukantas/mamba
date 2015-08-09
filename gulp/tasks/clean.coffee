gulp = require 'gulp'
del = require 'del'
{BUILD, DEST} = require '../shared'


post_delete = (base) ->
  console.log "Deleted all files in #{base}."


gulp.task 'clean:public', ->
  dest = DEST.base()
  del "#{dest}/*", force: true, post_delete.bind(null, base)


gulp.task 'clean:build', ->
  base = BUILD.base()
  del "#{base}/*", force: true, post_delete.bind(null, base)


gulp.task('clean', gulp.parallel('clean:build', 'clean:public'))