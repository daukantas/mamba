gulp = require 'gulp'
bower_files = require 'main-bower-files'


PATHS =
  suffix: (suffix) ->
    (suffix && ('/' + suffix )) || ''
  build_filepath: (file, options) ->
    if options.base
      file = "#{options.base}/#{file}"
    file


APP =
  base: ->
    'app'
  cjsx: ->
    "#{@base()}/**/*.{cjsx,coffee}"
  template: ->
    "#{@base()}/index.html"


BUILD =
  base: ->
    'build'
  entries: ->
    ["#{@base()}/mamba.js"]
  css: ->
    "#{@base()}/**/*.css"


DEST =
  base: ->
    'public'
  js: (suffix) ->
    "#{@base()}/js#{PATHS.suffix(suffix)}"
  css: (suffix) ->
    "#{@base()}/css#{PATHS.suffix(suffix)}"
  css_bundle: (options = {fullpath: false})->
    PATHS.build_filepath('app.css', base: @_parse_base_css(options))
  _parse_base_js: (options) ->
    (options.fullpath && "#{@base()}/js") || ''
  _parse_base_css: (options) ->
    (options.fullpath && "#{@base()}/css") || ''
  srcmap: (options = {fullpath: false}) ->
    PATHS.build_filepath('mamba.js.map', base: @_parse_base_js(options))
  bundle: (options = {fullpath: false}) ->
    PATHS.build_filepath('mamba.js', base: @_parse_base_js(options))
  template: ->
    "#{@base()}/index.html"

  bower:
    base: ->
      'public/bower'
    _parse_base: (options) ->
      (options.fullpath && @base()) || ''
    jsfile: (options = {fullpath: false}) ->
      PATHS.build_filepath('bower.min.js', base: @_parse_base(options))
    cssfile: (options = {fullpath: false}) ->
      PATHS.build_filepath('bower.min.css', base: @_parse_base(options))


BOWER =
  source: bower_files()
  stream: (filter) ->
    gulp
      .src @source
      .pipe filter


module.exports = {APP, BOWER, BUILD, DEST}