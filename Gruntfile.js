module.exports = function config(grunt) {
    var config = {
        elm: {
            default: {
                files: {
                    'dist/Main.js': 'src/Main.elm'
                }
            }
        },
        connect: {
            default: {
                options: {
                    port: 8080,
                    base: 'dist',
                    keepalive: false
                }
            }
        },
        watch: {
            elm: {
                files: [
                    'src/**/*.elm'
                ],
                tasks: ['elm:default']
            }
        }
    };
    
    grunt.initConfig(config);
    
    grunt.loadNpmTasks('grunt-elm');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    
    grunt.registerTask('serve', [
        'elm:default',
        'connect:default',
        'watch:elm'
    ]);
};

