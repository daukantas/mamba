Mamba = require './mamba'
settings = require './settings'
{keyhandler, renderer, xy} = require './util'

_ = require 'underscore'
$ = window.$


class Game
  ###
    Has-one Renderer
    Has-one Keyhandler
  ###

  @motion_keys =
    37: xy.value_of(0, -1)  # L
    38: xy.value_of(-1, 0)  # U
    39: xy.value_of(0, +1)  # R
    40: xy.value_of(+1, 0)  # D

  @method_keys =
    82: '__restart'

  constructor: (grid_node) ->
    @_reset_mamba()
    @_keyhandler = keyhandler
      .from_handler(@_keyup, $)
      .handle()
    @_renderer = renderer
      .mount(grid_node)
      .render(_.extend @_renderprops(), reset: true)

  _reset_mamba: ->
    @_mamba = Mamba.at_position(xy.random())

  _keyup: (keycode) =>
    motion = @constructor.motion_keys[keycode]
    method = @constructor.method_keys[keycode]
    if motion?
      @_mamba.impulse(motion)
      (!@_renderer.looping()) && @_renderer.loop(@_renderloop_hook)
    else if method?
      @[method]()

  __restart: ->
    @_reset_mamba()
    @_renderer.reset(@_renderprops())

  _renderloop_hook: =>
    @_mamba.move()
    @_renderprops()

  _renderprops: =>
    mamba: @_mamba
    mode: settings.MODE.easy


if $?
  new Game $('#mamba')[0]
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"