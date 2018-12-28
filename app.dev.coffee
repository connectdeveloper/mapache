axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
contentful   = require 'roots-contentful'
config       = require './contentful_dev'
marked       = require 'marked'
sass         = require 'roots-sass'
dateFormat   = require './date'
S            = require 'string'
records      = require 'roots-records'

marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: false
});

jade:
  pretty: true

module.exports =
  ignores: [
    'readme.md', '**/layout.*','assets/_redirects','**/_*.jade','**/_*.css', '.gitignore', 'contentful.coffee', 'contentful_local.coffee', 'app.local.coffee', 'app.coffee', 'date.coffee', 'scss', '_pages/', '_tabs/', 
    'Makefile', 'ship*', 'config.codekit', 'views/style_guide/*'
  ]

 #stylus:
   # use: [axis(), rupture(), autoprefixer()]

  locals:
    marked: marked
    dateFormat : dateFormat
    S : S


  extensions: [
    sass(files: "assets/scss/app.scss", out: 'css/app.css', style: 'compressed'), 
    contentful(config),
    records(suntimes: { file: 'views/data/suntimes.json' })
  ]
  #extensions: [contentful(config)]
