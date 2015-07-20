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
    "#{@base()}/**/*.cjsx"
  template: ->
    "#{@base()}/index.html"


BUILD =
  base: ->
    'build'
  entries: ->
    ["#{@base()}/grid/index.js"]

DEST =
  base: ->
    'public'
  js: (suffix) ->
    "#{@base()}/js#{PATHS.suffix(suffix)}"
  _parse_base: (options) ->
    (options.fullpath && "#{@base()}/js") || ''
  srcmap: (options = {fullpath: false}) ->
    PATHS.build_filepath('mamba.js.map', base: @_parse_base(options))
  bundle: (options = {fullpath: false}) ->
    PATHS.build_filepath('mamba.js', base: @_parse_base(options))
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