Grid = require './grid'
Mamba = require './mamba'
settings = require './settings'


$ = window.$

if $?
  new Game
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"


class Keyhandler

  constructor: (handler) ->
    @_handler = _.compose handler, @_extract_keycode

  @from_handler: (handler) ->
    new @(handler)

  reset: ->
    @_$(document).off('keyup', @_handler)
    @handle()
    @

  _extract_keycode: (ev) ->
    ev.which

  handle: ->
    @_$(document).off('keyup', @_handler)


###
  Responsibilities:

    - talks to React.js grid
###
class Renderer

  constructor: (@html_element) ->
    Grid.html_element(@html_element)
    @_interval = null

  @mount: (html_element) ->
    new @(html_element)

  pause: ->
    @_render(stop: true)
    @_stop()

  _render: (props = {}) =>
    Grid.render _.defaults(props, stop: false)

  reset: ->
    Grid.render _.defaults(props, reset: true)
    @_clear()

  _clear: ->
    clearInterval @_interval
    @_interval = null

  looping: ->
    @_interval?

  loop: (props_fn) ->
    render_fn = _.compose @render, props_fn
    @_interval = setInterval render_fn, settings.render_interval



class Game
  ###
    Has-one Renderer
    Has-one Keyhandler
  ###

  @impulse_keymap =
    37:
      x: -1
      y: 0
    38:
      x: 0
      y: 1
    39:
      x: 1
      y: 0
    40:
      x: 0
      y: -1

  @control_keymap =
    82: '_restart'
    80: '_pause'

  @node = $('#mamba')[0]

  constructor: ->
    @_reset_mamba()
    @_keyhandler = Keyhandler.from_handler(@_keyup)
      .handle()
    @_renderer = Renderer.mount(@constructor.node)
      .loop(@_renderprops)

  _reset_mamba: ->
    @_mamba = Mamba.at_position settings.GRID.start_position()

  _keyup: (keycode) =>
    impulse = @constructor.impulse_map[keycode]
    control = @constructor.control_map[keycode]
    if impulse?
      (!@_renderer.looping()) && @_renderer.loop(@_renderprops)
      @_mamba.impulse(impulse)
    else if control?
      @[control]()

  _restart: ->
    @_reset_mamba()
    @_renderer.reset()
    @_keyhandler.reset()

  _pause: ->
    @_renderer.pause()

  _renderprops: (props = {stop: false}) =>
    _.extend props, head: @_mamba.head()