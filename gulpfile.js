// include the required packages. 
var gulp = require('gulp'),
  standard = require('gulp-standard')
 
gulp.task('standard', function () {
  return gulp.src(['./app.js'])
    .pipe(standard())
    .pipe(standard.reporter('default', {
      breakOnError: true
    }))
})

var beautify = require('gulp-beautify');

gulp.task('beautify', function() {
  gulp.src('./app.js')
    .pipe(beautify({indent_size: 2}))
    .pipe(gulp.dest('./'))
});

// var gulpBowerFiles = require('gulp-bower-files');
 
// gulp.task("bower-files", function(){
//     gulpBowerFiles().pipe(gulp.dest("./lib"));
// });

// var gulp = require('gulp');
var mainBowerFiles = require('main-bower-files');
 
gulp.task('bower-files', function() {
  console.log(mainBowerFiles());
    return gulp.src(mainBowerFiles())
        .pipe(gulp.dest("./vendor/"))
});

// var inject = require('gulp-inject');

// gulp.task('bower-files', function() {
//   return gulp.src('./index.html')
//     .pipe(inject(gulp.src(mainBowerFiles(), {read: false}), {name: 'bower'}))
//     .pipe(gulp.dest("./"))
// });

wiredep = require('gulp-wiredep')
 
gulp.task('wiredep', function () {
  gulp.src('./index.html')
    .pipe(wiredep({
      fileTypes: {
        html: {
          replace: {
            js: function(filePath) {
              return '<script src="vendor/' + filePath.split('/').pop() + '"></script>'
            },
            css: function(filePath) {
              return '<link rel="stylesheet" href="vendor/' + filePath.split('/').pop() + '" />'
            }
          }
          
        }
      }
      // optional: 'configuration',
      // goes: 'here'
    }))
    .pipe(gulp.dest('./'));
});

gulp.task('build', ['bower-files', 'wiredep'])


var angularFilesort = require('gulp-angular-filesort'),
    inject = require('gulp-inject');
 
gulp.task('inject', function () {
gulp.src('./index.html')
  .pipe(inject(
    gulp.src(['*.js', '!./main.js', '!gulpfile.js']) // gulp-angular-filesort depends on file contents, so don't use {read: false} here 
      .pipe(angularFilesort())
    ))
  .pipe(gulp.dest('./'));
});
