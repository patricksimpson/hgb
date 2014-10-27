# libs
fs          = require('fs')
gulp        = require("gulp")
browserSync = require("browser-sync")
reload      = browserSync.reload
harp        = require("harp")
markdown    = require("gulp-markdown-to-json")
rename      = require("gulp-rename")
extend      = require('gulp-extend')
wrap        = require('gulp-wrap')
glob        = require('glob')
es          = require('event-stream')
gutil       = require('gulp-util')
concat      = require('gulp-concat-util')
del         = require('del')
rename      = require("gulp-rename")
runSequence = require('gulp-run-sequence')
replace     = require('gulp-replace')

gulp.task "serve", ->
  harp.server __dirname+'/app',
    port: 9000
  , ->
    browserSync
      proxy: "localhost:9000"
      open: false
      notify:
        styles: [
          "opacity: 0"
          "position: absolute"
        ]

    gulp.watch "app/styles/*", ->
      reload "main.css",
        stream: true

    gulp.watch ["app/*", "app/scripts/*"], ->
      reload()

    gulp.watch ["app/posts-content/*.md"], ['post-build']

gulp.task "post-markdown", ->
  gulp.src("app/posts-content/*.md")
    .pipe(markdown(
      pedantic: true
      smartypants: true
    ))
    .pipe(gulp.dest("app/posts/meta"))

gulp.task 'post-template', ->
  files = glob.sync('app/posts/meta/*.json')
  streams = files.map((file) ->
    path = file.split('_')[0]
    filename = file.split('_')[1].split('.')[0]
    data = JSON.parse(fs.readFileSync(file, 'utf8'))
    delete data.body
    gulp.src(file)
      .pipe(wrap('{"'+ filename + '": '+ JSON.stringify(data) + '}'))
      .pipe(rename(path + '/temp/' +'_' + data.order + '-' + filename + '.json'))
      .pipe(gulp.dest('./'))
  )
  es.merge.apply(es, streams)

gulp.task 'post-data', ->
  del('app/posts/_data.json')
  gulp.src('app/posts/meta/temp/*.json')
    .pipe(extend('app/posts/_data.json'))
    .pipe(gulp.dest('./'))

gulp.task 'post-clean', ->
  files = glob.sync('app/posts/meta/*.json')
  del('app/posts/meta')
  del('app/posts/meta/temp')

gulp.task 'post-compile', ->
  del('app/posts/*.jade')
  files = glob.sync('app/posts/meta/*.json')
  streams = files.map((file) ->
    filename = file.split('_')[1].split('.')[0]
    data = JSON.parse(fs.readFileSync(file, 'utf8'))
    gulp.src('app/_layout-posts.jade')
      .pipe(rename('app/posts/' + filename + '.jade'))
      .pipe(replace('%BODY%', data.body))
      .pipe(gulp.dest('./'))

  )
  es.merge.apply(es, streams)

gulp.task 'post-build', ->
  runSequence('post-markdown', 'post-template', 'post-data','post-compile', 'post-clean')

gulp.task "default", ["serve", "post-build"]
