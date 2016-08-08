module.exports = function config(grunt) {
    var config = {
        elm_make: {
            default: {
                files: {
                    'dist/Main.js': 'src/Main.elm'
                }
            }
        },
        uglify: {
            default: {
                files: {
                    'dist/Main.compiled.js': 'dist/Main.js'
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
                tasks: [
                    'elm_make:default', 
                    'uglify:default'
                ]
            }
        }
    };
    
    grunt.initConfig(config);
    
    grunt.loadNpmTasks('grunt-elm-make');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    
    grunt.registerTask('serve', [
        'elm_make:default',
        'uglify:default',
        'connect:default',
        'watch:elm'
    ]);
};

