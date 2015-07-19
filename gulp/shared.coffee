gulp = require 'gulp'
bower_files = require 'main-bower-files'


path_suffix = (suffix) ->
  (suffix && ('/' + suffix )) || ''


APP =
  _base: ->
    'app'

  entries: ->
    [@js('grid.js')]

  jsx: ->
    "#{@_base()}/jsx/**.jsx"

  js: (suffix) ->
    "#{@_base()}/js#{path_suffix(suffix)}"

  template: ->
    "#{@_base()}/index.html"

DEST =
  base: ->
    'public'

  js: (suffix) ->
    "#{@base()}/js#{path_suffix(suffix)}"

  _file: (file, options) ->
    if options.fullpath
      file = "#{@base()}/#{file}"
    file

  srcmap: (options = {fullpath: false}) ->
    @_file('js/mamba.js.map', options)

  bundle: (options = {fullpath: false}) ->
    @_file('js/mamba.js', options)

  template: ->
    "#{@base()}/index.html"

  BOWER:

    base: ->
      'public/bower'

    jsfile: (options = {fullpath: false}) ->
      DEST._file.call(@, 'bower.min.js', options)

    cssfile: (options = {fullpath: false}) ->
      DEST._file.call(@, 'bower.min.css', options)


BOWER =

  source: bower_files()

  stream: (filter) ->
    gulp
      .src @source
      .pipe filter


module.exports = {APP, DEST, BOWER}