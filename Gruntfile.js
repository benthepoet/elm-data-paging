module.exports = function config(grunt) {
    var config = {
        run: {
            make: {
                cmd: 'elm-make',
                args: [
                    'src/Main.elm',
                    '--output=dist/Main.js'
                ]
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
                    'run:make', 
                    'uglify:default'
                ]
            }
        }
    };
    
    grunt.initConfig(config);
    
    grunt.loadNpmTasks('grunt-run');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    
    grunt.registerTask('serve', [
        'run:make',
        'uglify:default',
        'connect:default',
        'watch:elm'
    ]);
};

