var
	gulp		= require('gulp'),
	coffee		= require('gulp-coffee'),
	rename		= require('gulp-rename'),
	filesize	= require('gulp-filesize'),
	rename		= require('gulp-rename'),
	streamify	= require('gulp-streamify'),
	uglify		= require('gulp-uglify');

var pkg = require('./package.json');

gulp.task('default', function(){
	gulp.src('./src/NaiveBayesClassifier.coffee')
		.pipe( coffee({bare: true}) )
		.pipe( rename(pkg.name + '.js') )
		.pipe( gulp.dest('dist') )
		.pipe( rename(pkg.name + '.min.js') )
		.pipe( streamify(uglify()) )
		.pipe( gulp.dest('dist') );
	// todo: filesize
});