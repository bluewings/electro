'use strict';

var childProcess, electron, gulp, runSequence;

childProcess = require('child_process');
electron = require('electron-prebuilt');
gulp = require('gulp');
runSequence = require('run-sequence');


gulp.task('spawn', function () {
  childProcess.spawn(electron, ['./build'], {
    stdio: 'inherit'
  }).on('close', function () {
    // User closed the app. Kill the host process.
    process.exit();
  });
});

gulp.task('start', function (cb) {
  runSequence('build', 'watch', 'spawn', cb);
  // ['copy:misc', 'copy:vendor', 'inject:scss'], ['templates', 'styles', 'scripts:coffee', 'scripts:js'],
  // 'inject:index',
  // cb);
});