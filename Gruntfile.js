module.exports = function(grunt) {

  grunt.initConfig({
    raml2html: {
      all: {
        files: {
          'docs/api/v1/main.html': ['docs/api/v1/main.raml'],
        }
      }
    },
  });

  grunt.loadNpmTasks('grunt-raml2html');
};
