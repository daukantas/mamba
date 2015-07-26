Mamba = require './mamba'
Cell = require './cell'
settings = require './settings'
{keyhandler, renderer, position} = require './util'

_ = require 'underscore'
$ = window.$


class Game
  ###
    Has-one Renderer
    Has-one Keyhandler
  ###

  @motion_keys =
    37: position.value_of(0, -1)  # L
    38: position.value_of(-1, 0)  # U
    39: position.value_of(0, +1)  # R
    40: position.value_of(+1, 0)  # D

  @method_keys =
    82: '__restart'

  constructor: (grid_node) ->
    @_lost = false
    @_reset_mamba()
    @_keyhandler = keyhandler
      .from_handler(@_keyup, $)
      .handle()
    @_renderer = renderer
      .mount(grid_node)
      .render(@_renderprops())

  _reset_mamba: ->
    @_mamba = Mamba.at_position(
      position.random(settings.GRID.dimension - 1))

  _keyup: (keycode) =>
    motion = @constructor.motion_keys[keycode]
    method = @constructor.method_keys[keycode]
    if motion && !@_lost
      @_mamba.motion(motion)
      (!@_renderer.looping()) && @_renderer.loop(
        @_renderloop_hook, settings.RENDER.interval)
    else if method?
      @[method]()

  __restart: ->
    @_lost = false
    @_reset_mamba()
    @_renderer.reset(@_renderprops())

  _renderloop_hook: =>
    @_mamba.move()
    @_renderprops()

  _renderprops: (props = {}) =>
    _.defaults props,
      mamba: @_mamba
      on_collision: @_on_collision
      lost: @_lost

  _on_collision: (cell) =>
    if cell is Cell.Wall
      @_lost = true
      @_mamba.motion(null)
      @_mamba.rewind()    # this is a hack for the view-layer; no cell-overlap during collision
      @_renderer.update @_renderprops(), =>
        @_renderer.stop()
    else if cell is Cell.Item
      @_mamba.grow()

if $?
  new Game $('#mamba')[0]
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"