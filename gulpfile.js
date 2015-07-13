var gulp = require('gulp');
var react = require('gulp-react');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');


var DIST = {

  base: function() {
    return 'public';
  },

  js: function(pattern) {
    var suffix = (pattern && ('/' + pattern )) || '';

    return this.base() + '/' + 'js' + suffix;
  }

};


gulp.task('browserify', function() {
  return browserify({entries: DIST.js('grid.js'), debug: true})
    .bundle()
    .pipe(source(DIST.js('mamba.js')))
    .pipe(buffer())
    .pipe(gulp.dest('./'));
});

gulp.task('react', function() {
  gulp
    .src(DIST.js('/**.jsx'))
    .pipe(react())
    .pipe(gulp.dest(DIST.js()))
});


gulp.task('build', gulp.series('react', 'browserify'));