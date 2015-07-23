Grid = require './grid'
Mamba = require './mamba'
settings = require './settings'

###
  Like a controller; responsibilities:

    - binding key events to game actions
    - passing props to Grid (based on key events)
###
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

  @dependencies = ['$', 'Grid']

  constructor: (dependencies = {}) ->
    for dependency in @constructor.dependencies
      if dependencies[dependency]?
        @["_#{dependency}"] = dependencies[dependency]
      else
        throw new Error("GameLoop needs dependency: #{dependency}")

    @_Grid.html_element(@_$('#mamba')[0])
    @_Grid.render(reset: true)
    @_set_keyevents(activate: true)
    @_interval = null
    @

  _reset_keyevents: ->
    @_set_keyevents(activate: false)
    @_set_keyevents(activate: true)

  _set_keyevents: (options = {activate: true}) ->
    if options.activate
      @_$(document).keyup @_keyhandler
    else
      @_$(document).off('keyup', @_keyhandler)

  play: ->
    @_mamba = Mamba.at_position(
      settings.GRID.start_position())
    @_interval = setInterval @_render.bind(@), settings.refresh_milliseconds

  # bound to the instance, for convenience & cleanup
  _keyhandler: (event) =>
    keycode = event.which
    impulse = @constructor.impulse_map[keycode]
    control = @constructor.control_map[keycode]
    if impulse?
      (!@_interval?) && @play()
      @_mamba.impulse(impulse)
    else if control?
      @[control]()

  _clear_interval: ->
    clearInterval @_interval
    @_interval = null

  _restart: ->
    @_clear_interval()
    @_reset_keyevents()

    @_mamba = Mamba.at_position(
      settings.GRID.start_position())
    @_render(reset: true)

  _render: (options = {reset: false}) ->
    @_Grid.render(reset: options.reset, head: @_mamba.head())


$ = window.$

if $?
  gameloop = new GameLoop({$, Grid})
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"