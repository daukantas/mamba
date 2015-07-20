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

  @dependencies = ['$', 'Mamba', 'settings']

  constructor: (dependencies = {}) ->
    for dependency in @constructor.dependencies
      if dependencies[dependency]?
        @[dependency] = dependencies[dependency]
      else
        throw new Error("GameLoop needs dependency: #{dependency}")
    @

  _bind_keyevents: ->
    @$(document).keyup @_keyhandler

  start: ->
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
    @start()
    console.info('Restarted game!')


$ = window.$

if $?
  Mamba = require './mamba'
  settings = require './settings'

  gameloop = new GameLoop({$, Mamba, settings})
  gameloop.start()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"