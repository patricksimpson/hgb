# libs
gulp        = require("gulp")
browserSync = require("browser-sync")
reload      = browserSync.reload
harp        = require("harp")
markdown    = require("gulp-markdown-to-json")

gulp.task "serve", ->
  harp.server __dirname,
    port: 9000
  , ->
    browserSync
      proxy: "localhost:9000"
      open: false

      # Hide the notification. It gets annoying
      notify:
        styles: [
          "opacity: 0"
          "position: absolute"
        ]

    gulp.watch "app/styles/*", ->
      reload "main.css",
        stream: true

      return

    gulp.watch ["app/*", "app/scripts/*"], ->
      reload()
      return

    gulp.watch ["posts/_*.md"], ->
      reload()
      return

    return
  return

gulp.task "markdown", ->
  gulp.src("./posts/*.md").pipe(markdown(
    pedantic: true
    smartypants: true
  )).pipe gulp.dest("./posts")
  return

gulp.task "default", ["serve", "markdown"]
