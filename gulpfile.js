// include the required packages. 
// var gulp = require('gulp'),
//   standard = require('gulp-standard')
 

require('./tasks/build');
require('./tasks/start');
require('./tasks/release/release');


// gulp.task('standard', function () {
//   return gulp.src(['./app.js'])
//     .pipe(standard())
//     .pipe(standard.reporter('default', {
//       breakOnError: true
//     }))
// })

// var beautify = require('gulp-beautify');

// gulp.task('beautify', function() {
//   gulp.src('./app.js')
//     .pipe(beautify({indent_size: 2}))
//     .pipe(gulp.dest('./'))
// });

// var gulpBowerFiles = require('gulp-bower-files');
 
// gulp.task("bower-files", function(){
//     gulpBowerFiles().pipe(gulp.dest("./lib"));
// });

// var gulp = require('gulp');


// var inject = require('gulp-inject');

// gulp.task('bower-files', function() {
//   return gulp.src('./index.html')
//     .pipe(inject(gulp.src(mainBowerFiles(), {read: false}), {name: 'bower'}))
//     .pipe(gulp.dest("./"))
// });

// wiredep = require('gulp-wiredep')
 


// gulp.task('build', ['bower-files', 'wiredep'])


