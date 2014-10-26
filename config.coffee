# libs
gulp        = require("gulp")
browserSync = require("browser-sync")
reload      = browserSync.reload
harp        = require("harp")

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

    return

  return


gulp.task "default", ["serve"]
