module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json'),
    concat:
      options:
        separator: ';'
        stripBanners: true
      dist:
        src:[
          "bower_components/jquery/jquery.min.js"
          "bower_components/jquery/jquery-migrate.min.js"
          "bower_components/underscore/underscore.js"
          "bower_components/backbone/backbone.js"
          "bower_components/jquery.lazyload/jquery.lazyload.min.js"
          "bower_components/eventEmitter/EventEmitter.js"
          "bower_components/eventie/eventie.js"
          "bower_components/doc-ready/doc-ready.js"
          "bower_components/get-style-property/get-style-property.js"
          "bower_components/get-size/get-size.js"
          "bower_components/jquery-bridget/jquery.bridget.js"
          "bower_components/matches-selector/matches-selector.js"
          "bower_components/outlayer/item.js"
          "bower_components/outlayer/outlayer.js"
          "bower_components/masonry/masonry.js"
          "bower_components/isotope/js/layout-mode.js"
          "bower_components/isotope/js/item.js"
          "bower_components/isotope/js/isotope.js"
          "bower_components/isotope/js/layout-modes/masonry.js"
          "bower_components/isotope/js/layout-modes/fir-rows.js"
          "bower_components/isotope/js/layout-modes/fir-columns.js"
          "bower_components/bootstrap/js/transition.js"
          "bower_components/bootstrap/js/button.js"
          "bower_components/bootstrap/js/collapse.js"
          "src/files/js/libs/log.js"
          "out/js/script.js"
        ]
        dest: 'out/js/scripts.min.js'
    uglify:
      options:
        mangle: false
      my_target:
        files:
          'out/js/scripts.min.js': ['out/js/scripts.min.js']
    cssmin:
      minify:
        expand: true
        cwd: 'out/css'
        src: ['out/css/*.css']
        dest: 'out/css'
        ext: '.min.css'
    copy:
      main:
        files: [
          src: ['src/files/bower_components/modernizr/modernizr.js']
          dest: 'out/js/libs/modernizr.js'
        ]
    clean: [
      'out/css/*.less'
      'out/css/font-awesome'
      'out/*.jade'
      'out/js/*.coffee'
      'out/js/libs/.jshintrc'
      'out/bower_components/'
      'out/js/libs/jquery-ui-1.9.2.custom.min.js'
      'out/js/libs/log.js'
      ]

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'default', ['concat', 'cssmin', 'copy', 'clean']


