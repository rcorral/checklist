'use strict';
require('coffee-script').register();

var gulp = require('gulp'),
    autoprefixer = require('gulp-autoprefixer'),
    browserify = require('browserify'),
    clean = require('gulp-clean'),
    concat = require('gulp-concat'),
    coffee = require('coffee-script'),
    debug = require('debug')('debug'),
    debugError = require('debug')('error'),
    env = require('node-env-file'),
    es = require('event-stream'),
    order = require('gulp-order'),
    path = require('path'),
    refresh = require('gulp-livereload'),
    rename = require('gulp-rename'),
    spawn = require('child_process').spawn,
    stylus = require('gulp-stylus'),
    through = require('through'),
    transform = require('vinyl-transform');

env(path.join(__dirname, '/.env'));

gulp.task('clean-css', function() {
    debug('clean-css');
    gulp.src(['public/assets/*.css'], {read: false})
        .pipe(clean());
});

gulp.task('compile-css', ['clean-css'], function() {
    debug('stylus');

    var deps = gulp.src([
        'node_modules/bootstrap/dist/css/bootstrap.min.css'
        ]);

    var assets = gulp.src('assets/index.styl')
            .pipe(stylus())
            .pipe(autoprefixer(['> 1%', 'last 2 versions']));

    // Merge both streams
    var bundle = es.merge(deps, assets)
        .pipe(order([
            'node_modules/bootstrap/dist/css/bootstrap.min.css',
            'assets/index.styl'
            ]))
        .pipe(concat('bundle.css'))
        .pipe(gulp.dest('./public/assets/'));
});

gulp.task('clean-js', function() {
    debug('clean-js');
    gulp.src(['public/assets/*.js'], {read: false})
        .pipe(clean());
});

gulp.task('compile-js', ['clean-js'], function(done) {
    debug('compile-js');
    var browserified = transform(function(filename) {
        var b = browserify(filename);
        b.transform(function (file) {
            var data = '';
            return through(write, end);

            function write (buf) { data += buf }
            function end () {
                this.queue(coffee.compile(data));
                this.queue(null);
            }
        });

        return b.bundle()
            .on('error', function(err){
                debugError(err.message);
                // end this stream
                this.end();
            });
    });

    // Compile vendor dependencies to vendor.js
    var vendor = gulp.src([
        './node_modules/jquery/dist/jquery.js',
        './node_modules/underscore/underscore.js',
        './node_modules/backbone/backbone.js',
        './node_modules/bootstrap/dist/js/bootstrap.js',
        './lib/jquery/*.*',
        ])
        .pipe(concat('vendor.js'))
        .pipe(gulp.dest('./public/assets'));

    // bundle.js
    var bundle = gulp.src(['./assets/index.coffee'])
        .pipe(browserified)
        .pipe(rename('bundle.js'))
        .pipe(gulp.dest('./public/assets'));

    bundle.on('end', function() {
            // There's some weird timing issue where the file isn't fully written
            setTimeout(done, 500);
        });
});

gulp.task('compile', ['compile-css', 'compile-js']);

gulp.task('watch', ['compile'], function() {
    refresh.listen(process.env.NODE_LIVERELOAD_PORT);

    // Watch our scripts, and when they change run browserify
    gulp.watch([
        'apps/**/client.coffee',
        'apps/**/client/*.coffee',
        'apps/**/*.styl',
        'assets/**/*.coffee',
        'assets/**/*.styl',
        'components/**/*.coffee',
        'collections/**/*.coffee',
        'components/**/*.styl',
        'models/**/*.coffee'
        ], ['compile']);

    // Watch bundled assets
    gulp.watch('public/assets/bundle.*').on('change', refresh.changed);
});

gulp.task('default', ['watch'], function() {
    // Start server
    spawn('bin/www', [], {
        stdio: 'inherit'
    });
});
