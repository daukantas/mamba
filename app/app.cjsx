Grid = require './grid'


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
    82: '_restart'

  constructor: (@$, @Mamba, @settings) ->
    @_start()

  _bind_keyevents: ->
    @$(document).keyup @_keyhandler

  _start: ->
    @_mamba = @Mamba.at_position(@settings.GRID.start_position())
    @_bind_keyevents(@_keyhandler)

  # bound to the instance, for convenience & cleanup
  _keyhandler: (event) =>
    keycode = event.which
    impulse = @constructor.impulse_map[keycode]
    control = @constructor.control_map[keycode]
    if impulse?
      @_mamba.impulse(impulse)
    else if control?
      @[control]()

  _restart: ->
    @$(document).off('keyup', @_keyhandler)
    @_start()
    console.info('Restarted game!')



$ = window.$

if $?
  Mamba = require './mamba'
  settings = require './settings'

  new GameLoop($, Mamba, settings)
else
  throw new Error 'jQuery must be loaded.'