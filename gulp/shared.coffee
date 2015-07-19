path_suffix = (suffix) ->
  (suffix && ('/' + suffix )) || ''


SRC =
  _base: ->
    'src'

  entries: ->
    [@js('grid.js')]

  jsx: ->
    "#{@_base()}/jsx/**.jsx"

  js: (suffix) ->
    "#{@_base()}/js#{path_suffix(suffix)}"


DST =
  _base: ->
    'public'

  js: (suffix) ->
    "#{@_base()}/js#{path_suffix(suffix)}"

  _js_file: (file, options) ->
    if options.fullpath
      file = @js(file)
    file

  srcmap: (options = {fullpath: false}) ->
    @_js_file('mamba.js.map', options)

  bundle: (options = {fullpath: false}) ->
    @_js_file('mamba.js', options)


module.exports = {SRC, DST}