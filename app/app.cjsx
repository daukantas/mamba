_ = require 'underscore'

Mamba = require './mamba'
Grid = require './grid'
{GRID} = require './settings'


class GameLoop

  @impulse_map =
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

  @control_map =
    82: 'restart'

  constructor: (@$) ->
    @_mamba = Mamba.at_position(GRID.start_position())
    @_bind_keyevents()

  _bind_keyevents: ->
    # TODO: clean this up when restarting the game
    @$(document).keyup (event) =>
      keycode = event.which
      impulse = @constructor.impulse_map[keycode]
      control = @constructor.control_map[keycode]
      if impulse?
        @_mamba.impulse(impulse)
      else if control?
        @[control]()

  restart: ->
    @_mamba = Mamba.at_position(GRID.start_position())
    console.info('Restarting game!')



$ = window.$

if $?
  new GameLoop($)
else
  throw new Error 'jQuery must be loaded.'