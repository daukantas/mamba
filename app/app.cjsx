Mamba = require './mamba'
settings = require './settings'
{keyhandler, renderer} = require './util'

_ = require 'underscore'
$ = window.$


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

  constructor: (grid_node) ->
    @_reset_mamba()
    @_keyhandler = keyhandler.from_handler(@_keyup, $)
      .handle()
    @_renderer = renderer.mount(grid_node)
      .loop(@_renderprops)

  _reset_mamba: ->
    @_mamba = Mamba.at_position(settings.GRID.start_position())

  _keyup: (keycode) =>
    impulse = @constructor.impulse_keymap[keycode]
    control = @constructor.control_keymap[keycode]
    if impulse?
      (!@_renderer.looping()) && @_renderer.loop(@_renderprops)
      @_mamba.impulse(impulse)
    else if control?
      @[control]()

  _restart: ->
    @_reset_mamba()
    @_renderer.reset(@_renderprops())
    @_keyhandler.reset()

  _renderprops: =>
    mamba: @_mamba
    mode: settings.MODE.easy


if $?
  new Game $('#mamba')[0]
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"