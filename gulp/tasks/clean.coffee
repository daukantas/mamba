gulp = require 'gulp'
del = require 'del'
_ = require 'underscore'
{BUILD, DEST} = require '../shared'


post_delete = (err, files) ->
  if files.length > 0
    console.info "Deleted files: \n\t#{files.join('\n\t')}"
  else
    console.info "Found nothing to delete!"

gulp.task 'clean:public', (done) ->
  base = DEST.base()
  del "#{base}/**/*.+(js|css|map|html)", _.compose(done, post_delete)


gulp.task 'clean:build', (done) ->
  base = BUILD.base()
  del "#{base}/*", _.compose(done, post_delete)


gulp.task('clean', gulp.parallel('clean:build', 'clean:public'))