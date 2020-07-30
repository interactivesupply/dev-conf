/// <binding ProjectOpened='default' />
// Sass configuration
var gulp = require('gulp');
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');
var browserSync = require('browser-sync').create();

//style paths
//var sassFiles = 'assets/styles/sass/**/*.scss',
var theme_roots = [
    'wp-content/themes/put_theme_name_here/'

];
var files_to_compile = 
[
    {
        fileName :  "theme",
        outputFolder: "css/",
        inputFolder: "sass/"
    },
    // {
    //     fileName :  "put_page_specific_css_name_here",
    // }
  ];

gulp.task('beautify-styles', gulp.series(function(done) {
    for (var j = 0; j < theme_roots.length; j++) {
        var theme_root = theme_roots[j];

        for (var i = 0; i < files_to_compile.length; i++) {
            var inputFolder = theme_root + (files_to_compile[i].inputFolder != undefined ?files_to_compile[i].inputFolder : "sass/page-templates/");
            var outputFolder = theme_root + (files_to_compile[i].outputFolder != undefined ?files_to_compile[i].outputFolder : "css/page-templates/");

            gulp.src(inputFolder + files_to_compile[i].fileName + ".scss")
            .pipe(sourcemaps.init())
            .pipe(sass().on('error', sass.logError))
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(outputFolder))
            .pipe(browserSync.stream());
        }
    }
    done();
}));

gulp.task('uglify-styles', gulp.series(function (done) {
    for (var j = 0; j < theme_roots.length; j++) {
        var theme_root = theme_roots[j];
        for (var i = 0; i < files_to_compile.length; i++) {
            var inputFolder = theme_root + (files_to_compile[i].inputFolder != undefined ? files_to_compile[i].inputFolder : "sass/page-templates/");
            var outputFolder = theme_root + (files_to_compile[i].outputFolder != undefined ? files_to_compile[i].outputFolder : "css/page-templates/");
   
            gulp.src(inputFolder + files_to_compile[i].fileName + ".scss")
                .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
                .pipe(concat(files_to_compile[i].fileName + ".min.css"))
                .pipe( gulp.dest(outputFolder));
        }

    }    

    done();
}));


gulp.task('default', gulp.series( 'uglify-styles', 'beautify-styles', function (done) {
     browserSync.init({
        //proxy: "https://dev.insureyonder.com",
        https: {
          key: "/Users/interactivesupply/src/dev-conf/ssl/dev.interactivesupply.com.key",
          cert: "/Users/interactivesupply/src/dev-conf/ssl/dev.interactivesupply.com.crt",
        }
    });
    for (var i = 0; i < theme_roots.length; i++) {
        gulp.watch(theme_roots[i] + 'sass/**/*.scss', gulp.series('uglify-styles','beautify-styles'));
    }
    done();

}));