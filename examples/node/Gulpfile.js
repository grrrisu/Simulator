var gulp = require("gulp");

var browserify = require("browserify");
var babelify = require("babelify");
//var rev = require("gulp-rev");
//var uglify = require("gulp-uglify");
//var gzip = require('gulp-gzip');
var vinylSourceStream = require('vinyl-source-stream');
var vinylBuffer = require('vinyl-buffer');
var liveReload = require("gulp-livereload");

gulp.task('default', ['watch']);

gulp.task('watch', ['compile'], function(){
  liveReload({start: true});
  gulp.watch("client/**/*.js", ["compile"]);
});

gulp.task('compile', function() {
  var sources = browserify({
    entries: './client/main.js',
    debug: true
  })
  .transform(babelify.configure());

  return sources.bundle()
    .pipe(vinylSourceStream('client.js'))
    .pipe(vinylBuffer())
    .pipe(gulp.dest('./public/javascripts/'))
    .pipe(liveReload());
});

// gulp.task('production', function() {
//   var sources = browserify({
//     entries: 'src/main.js',
//     debug: true
//   })
//   .transform(babelify.configure());
//
//   return sources.bundle()
//     .pipe(vinylSourceStream('app.js'))
//     .pipe(vinylBuffer())
//     .pipe(uglify())
//     .pipe(rev())
//     .pipe(gulp.dest('javascripts/'))
//     .pipe(gzip())
//     .pipe(gulp.dest('javascripts/'))
//     .pipe(rev.manifest())
//     .pipe(gulp.dest('javascripts/'))
// });
