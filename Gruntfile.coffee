module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      compileBare:
        options:
          bare: true
        files:
          'javascripts/marx.js': 'javascripts/coffee/marx.coffee'

    uglify:
      build:
        options:
          mangle: false
        files:
          "javascripts/marx.min.js": "javascripts/marx.js"


    sass:
      dist:
        files: [
          expand: true
          cwd: "stylesheets/scss"
          src: ["**/*.scss"]
          dest: "stylesheets/src"
          ext: ".css"
        ]

    imagemin:
      dynamic:
        files: [
          expand: true
          cwd: "images/"
          src: ["**/*.{png,jpg,gif}"]
          dest: "images/build/"
        ]

    watch:
      options:
        livereload: true

      css:
        files: ["stylesheets/scss/*.scss"]
        tasks: "sass"
        options:
          spawn: false

      coffee:
        files: ["javascripts/coffee/*.coffee"]
        tasks: "coffee"

      html:
        files: [
          "index.php"
          "index.html"
          "**/*.php"
          "**/*.html"
        ]

  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-imagemin"

  # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
  grunt.registerTask "default", ["coffee", "sass", "watch"]
  grunt.registerTask "build_production", ["coffee", "uglify", "sass", "imagemin"]