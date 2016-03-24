'use strict';

var $, del, dest, destDir, excludeNodes, gulp, mainBowerFiles, path, runSequence, src, srcDir;

gulp = require('gulp');
path = require('path');
del = require('del');
runSequence = require('run-sequence');
mainBowerFiles = require('main-bower-files');
$ = require('gulp-load-plugins')();

srcDir = path.join(__dirname, '..', 'app');
destDir = path.join(__dirname, '..', 'build');
excludeNodes = '!' + path.join(srcDir, 'node_modules/**');

src = {
  js: [path.join(srcDir, '**/*.js'), excludeNodes],
  coffee: [path.join(srcDir, '**/*.coffee'), excludeNodes],
  jade: {
    all: [path.join(srcDir, '**/*.jade'), excludeNodes],
    index: path.join(srcDir, 'index.jade')
  },
  scss: {
    all: [path.join(srcDir, '**/*.scss'), excludeNodes],
    main: path.join(srcDir, 'app.scss'),
    inject: [path.join(srcDir, '**/*.scss'), '!' + path.join(srcDir, 'app.scss'), excludeNodes]
  },
  copy: {
    nodeModules: path.join(srcDir, 'node_modules/**'),
    packageJson: path.join(srcDir, 'package.json')
  },
  bower: path.join(__dirname, '..', 'bower.json')
};

dest = {
  index: path.join(destDir, 'index.html'),
  vendor: path.join(destDir, 'vendor'),
  stylesheets: path.join(destDir, 'app.css'),
  scripts: [
    path.join(destDir, '**/*.js'),
    '!' + path.join(destDir, 'main.js'),
    '!' + path.join(destDir, 'vendor/**'),
    '!' + path.join(destDir, 'node_modules/**')
  ]
};

gulp.task('clean', del.bind(null, [destDir]));

gulp.task('templates', function () {
  return gulp.src(src.jade.all)
    .pipe($.plumber())
    .pipe($.jade({
      pretty: true
    }))
    .pipe(gulp.dest(destDir));
});

gulp.task('styles', function () {
  return gulp.src(src.scss.all)
    .pipe($.plumber())
    .pipe($.sass.sync({
      outputStyle: 'expanded',
      precision: 10,
      includesrc: ['.']
    }).on('error', $.sass.logError))
    .pipe(gulp.dest(destDir));
});

gulp.task('scripts:coffee', function () {
  return gulp.src(src.coffee)
    .pipe($.plumber())
    // .pipe($.sourcemaps.init())
    .pipe($.coffee())
    .pipe(gulp.dest(destDir));
});

gulp.task('scripts:js', function () {
  return gulp.src(src.js)
    .pipe($.plumber())
    .pipe($.jsbeautifier())
    .pipe(gulp.dest(destDir));
});

gulp.task('inject:index', function () {
  return gulp.src(dest.index)
    .pipe($.wiredep({
      fileTypes: {
        html: {
          replace: {
            js: function (filePath) {
              if (filePath.search(/jquery.js$/i) !== -1) {
                return '<script src="vendor/' + filePath.split('/').pop() + '" onload="window.$ = window.jQuery = module.exports;"></script>';
              } else {
                return '<script src="vendor/' + filePath.split('/').pop() + '"></script>';
              }
            },
            css: function (filePath) {
              return '<link rel="stylesheet" href="vendor/' + filePath.split('/').pop() + '">';
            }
          }
        }
      }
    }))
    .pipe($.inject(gulp.src(dest.scripts, {
        cwd: destDir
      })
      .pipe($.angularFilesort()), {
        transform: function (filePath) {
          return '<script src="' + filePath.replace(/^\//, '') + '"></script>';
        }
      }))
    .pipe($.inject(gulp.src(dest.stylesheets, {
      cwd: destDir,
      read: false
    }), {
      transform: function (filePath) {
        return '<link rel="stylesheet" href="' + filePath.replace(/^\//, '') + '">';
      }
    }))
    .pipe(gulp.dest(destDir));
});

gulp.task('inject:scss', function () {
  return gulp.src(src.scss.main)
    .pipe($.inject(gulp.src(src.scss.inject, {
      cwd: srcDir,
      read: false
    }), {
      transform: function (filePath) {
        return '@import "' + filePath.replace(/^\//, '') + '";';
      },
      starttag: '// inject',
      endtag: '// endinject'
    }))
    .pipe(gulp.dest(srcDir));
});

gulp.task('copy:misc', function () {
  gulp.src(src.copy.nodeModules)
    .pipe(gulp.dest(path.join(destDir, 'node_modules')));
  gulp.src(src.copy.packageJson)
    .pipe(gulp.dest(destDir));
});

gulp.task('copy:vendor', function () {
  gulp.src(mainBowerFiles())
    .pipe(gulp.dest(dest.vendor));
});

gulp.task('watch', function () {
  gulp.watch(src.bower, ['inject:index', 'copy:vendor']);
  gulp.watch(dest.index, ['inject:index']);
  gulp.watch(src.jade.all, ['templates']);
  gulp.watch(src.scss.all, ['styles']);
  gulp.watch(src.coffee, ['scripts:coffee']);
  gulp.watch(src.js, ['scripts:js']);
});

gulp.task('build', function (cb) {
  runSequence('clean',
    ['copy:misc', 'copy:vendor', 'inject:scss'],
    ['templates', 'styles', 'scripts:coffee', 'scripts:js'],
    'inject:index',
    cb);
});