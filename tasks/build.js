'use strict';

var $, del, dest, destDir, eventStream, excludeNodes, fsJetpack, getHashKey, gulp, mainBowerFiles, path, runSequence, src, srcDir, templateReplace;

gulp = require('gulp');
path = require('path');
del = require('del');
eventStream = require('event-stream');
runSequence = require('run-sequence');
mainBowerFiles = require('main-bower-files');
fsJetpack = require('fs-jetpack');
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
  copy: [
    path.join(srcDir, 'node_modules/**'),
    path.join(srcDir, 'package.json')
  ],
  bower: path.join(__dirname, '..', 'bower.json')
};

dest = {
  index: path.join(destDir, 'index.html'),
  vendor: path.join(destDir, 'vendor'),
  fonts: path.join(destDir, 'fonts'),
  stylesheets: path.join(destDir, 'app.css'),
  scripts: [
    path.join(destDir, '**/*.js'),
    '!' + path.join(destDir, 'main.js'),
    '!' + path.join(destDir, 'main/**'),
    '!' + path.join(destDir, 'lib/**'),
    '!' + path.join(destDir, 'vendor/**'),
    '!' + path.join(destDir, 'node_modules/**')
  ]
};

getHashKey = function (str) {
  var base16, base36, chr, hash, i, len;
  hash = 0;
  if (typeof str === 'object' && str !== null) {
    str = JSON.stringify(str);
  }
  str = str.replace(/\.[a-z]+$/, '').replace(/^\//, '');
  if (str.length === 0) {
    return hash;
  }
  i = 0;
  len = str.length;
  while (i < len) {
    chr = str.charCodeAt(i);
    hash = (hash << 5) - hash + chr;
    hash |= 0;
    i++;
  }
  base16 = hash.toString(16).replace(/[^a-z0-9]/g, '');
  base36 = hash.toString(36).replace(/[^a-z0-9]/g, '');
  hash = (parseInt(base16.substr(0, 1), 16) + 10).toString(36) + base36;
  return hash;
};

templateReplace = function () {
  return eventStream.map(function (file, cb) {
    var html, name;
    if (file.base && file.history && file.history[0] && file.history[0].search(/index.jade/) === -1) {
      name = getHashKey(file.history[0].replace(new RegExp('^' + file.base), ''));
      html = String(file.contents).trim();
      if (html.search(/^(<[a-z]+[^>]+ class=")([^>"]+)("[^>]*>)/) !== -1) {
        html = html.replace(/^(<[a-z]+[^>]+ class=")([^>"]+)("[^>]*>)/, '$1$2 ' + name + '$3');
      } else {
        html = html.replace(/^(<[a-z]+)/, '$1 class="' + name + '" ');
      }
      file.contents = new Buffer(html.replace(/^(<[^>]+)\s+>/, '$1>'));
    }
    cb(null, file);
  });
};

gulp.task('clean', del.bind(null, [destDir]));

gulp.task('templates', function () {
  return gulp.src(src.jade.all)
    .pipe($.plumber())
    .pipe($.jade({
      pretty: true
    }))
    .pipe(templateReplace())
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
    .pipe($.coffee())
    .pipe(gulp.dest(destDir));
});

gulp.task('scripts:js', function () {
  return gulp.src(src.js)
    .pipe($.plumber())
    .pipe($.jsbeautifier({
      indent_size: 2
    }))
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
        var name = getHashKey(filePath);
        return '.' + name + ' {\n' +
          '  @import "' + filePath.replace(/^\//, '') + '";\n' +
          '}';
      },
      starttag: '// inject',
      endtag: '// endinject'
    }))
    .pipe(gulp.dest(srcDir));
});

gulp.task('copy:vendor', function () {
  return gulp.src(mainBowerFiles())
    .pipe(gulp.dest(dest.vendor));
});

gulp.task('copy:fonts', function () {
  return gulp.src(mainBowerFiles('**/*.{eot,svg,ttf,woff,woff2}'))
    .pipe(gulp.dest(dest.fonts));
});

gulp.task('copy:misc', function () {
  return fsJetpack.copyAsync(srcDir, destDir, {
    overwrite: true,
    matching: src.copy
  });
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
  runSequence(
    'clean',
    ['copy:vendor', 'copy:fonts', 'copy:misc', 'inject:scss'],
    ['templates', 'styles', 'scripts:coffee', 'scripts:js'],
    'inject:index',
    cb
  );
});