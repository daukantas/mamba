var gulp = require('gulp');
var react = require('gulp-react');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');


var DIST = {
  _make_suffix: function(pattern) {
    return (pattern && ('/' + pattern )) || '';
  },

  base: function() {
    return 'public';
  },

  js: function(pattern) {
    return this.base() + '/' + 'js' + this._make_suffix(pattern);
  },

  jsx: function(pattern) {
    return this.base() + '/' + 'jsx' + this._make_suffix(pattern);
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
  return gulp
    .src(DIST.jsx('/**.jsx'))
    .pipe(react())
    .pipe(gulp.dest(DIST.js()))
});


gulp.task('build', gulp.series('react', 'browserify'));