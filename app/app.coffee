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
    @_reset_mamba()
    @_keyhandler = keyhandler
      .from_handler(@_keyup, $)
      .handle()
    @_renderer = renderer
      .mount(grid_node)
      .render(@_renderprops())

  _reset_mamba: ->
    @_mamba = Mamba.at_position(
      position.random(settings.GRID.dimension))

  _keyup: (keycode) =>
    motion = @constructor.motion_keys[keycode]
    method = @constructor.method_keys[keycode]
    if motion && !@_lost
      @_mamba.impulse(motion)
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

  _on_collision: (cell) =>
    if cell is Cell.Collision
      @_renderer.update(@_renderprops(lost: true), =>
        @_lost = true
        @_renderer.stop()
      )
    else if cell is Cell.Item
      @_mamba.grow()

if $?
  new Game $('#mamba')[0]
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"