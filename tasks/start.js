'use strict';

var childProcess, electron, gulp, runSequence;

childProcess = require('child_process');
electron = require('electron-prebuilt');
gulp = require('gulp');
runSequence = require('run-sequence');


gulp.task('spawn', function() {
  setTimeout(function() {
    childProcess.spawn(electron, ['./build'], {
      stdio: 'inherit'
    }).on('close', function() {
      // User closed the app. Kill the host process.
      process.exit();
    });
  }, 2000);
});

gulp.task('start', function(cb) {
  runSequence('build', 'watch', 'spawn', cb);
  // ['copy:misc', 'copy:vendor', 'inject:scss'], ['templates', 'styles', 'scripts:coffee', 'scripts:js'],
  // 'inject:index',
  // cb);
});