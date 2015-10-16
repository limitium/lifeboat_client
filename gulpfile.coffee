gulp = require 'gulp'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
ngClassify = require 'gulp-ng-classify'
watch = require 'gulp-watch'
browserSync = require('browser-sync').create()
reload = browserSync.reload
exec = require('child_process').exec;


buildFolder = './build'

gulp.task 'scripts', ->
  gulp.src('./src/**/*.coffee')
  .pipe concat('all.coffee')
  .pipe sourcemaps.init()
  .pipe ngClassify(
    appName: 'lb'
    controller:
      format: 'upperCamelCase'
      suffix: 'Controller'
    service:
      format: 'upperCamelCase'
      suffix: 'Service'
  )
  .pipe coffee()
  .pipe concat('app.min.js')
  .pipe sourcemaps.write()
  .pipe gulp.dest(buildFolder+'/js')
  .pipe(reload({stream: true}))


gulp.task 'vendor', ->
  gulp.src([
    'node_modules/lodash/index.js'
    'node_modules/jquery/dist/jquery.js'
    'node_modules/bootstrap/dist/js/bootstrap.min.js'
    'node_modules/angular/angular.js'
    'node_modules/angular-ui-bootstrap/ui-bootstrap-tpls.min.js'
    'node_modules/angular-resource/angular-resource.min.js'
    'node_modules/angular-ui-router/release/angular-ui-router.js'
    'node_modules/angular-moment/node_modules/moment/moment.js'
    'node_modules/angular-moment/angular-moment.js'
    'node_modules/angular-sanitize/angular-sanitize.min.js'
  ])
  .pipe concat('vendor.min.js')
  .pipe gulp.dest(buildFolder+'/js')

  gulp.src([
    'node_modules/font-awesome/css/font-awesome.min.css'
  ])
  .pipe concat('vendor.min.css')
  .pipe(gulp.dest(buildFolder+'/css'))

  gulp.src([
    'node_modules/font-awesome/fonts/**/*'
  ])
  .pipe(gulp.dest(buildFolder+'/fonts'))

gulp.task 'images', ->
  gulp.src([
    './src/assets/**/*'
  ])
  .pipe(gulp.dest(buildFolder ))


gulp.task 'styles', ->
  gulp.src([
    './src/less/main.less'
  ])
  .pipe(less())
  .pipe concat('app.css')
  .pipe(gulp.dest(buildFolder+'/css'))
  .pipe(reload({stream: true}))

gulp.task 'html', ->
  gulp.src(['./src/**/*html'])
  .pipe(gulp.dest(buildFolder+''))
  .pipe(reload({stream: true}))

gulp.task 'browser-sync', ->
  browserSync.init({
    server: {
      baseDir: buildFolder
    }
  })

gulp.task 'watch', ->
  gulp.watch(['./src/**/*.coffee'], ['scripts'])
  gulp.watch(['./src/**/*.html'], ['html'])
  gulp.watch(['./src/**/*.less'], ['styles'])

gulp.task('default', ['vendor', 'scripts', 'images','styles', 'html', 'browser-sync', 'watch'])