Snake = require '../snake'
{KeyDownAction, KeySender} = require '../actions'
settings = require '../settings'
Cell = require '../cell'
Grid = require '../views/grid'

dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'
{Ticker, XY, GAME_OVER} = require '../utility'


CHANGE_EVENT = 'change'

MOTION_KEYS = Immutable.Map [
  [37, XY.value_of(0, -1)]  # L
  [38, XY.value_of(-1, 0)]  # U
  [39, XY.value_of(0, +1)]  # R
  [40, XY.value_of(+1, 0)]  # D
]

METHOD_KEYS = Immutable.Map [
  [82, '__restart']
]


cells = Immutable.OrderedMap().withMutations (mutative_cells) ->
  range = settings.GRID.range()
  for row in range
    for col in range
      mutative_cells.set XY.value_of(row, col), null

snake = null
game_over = null
Items = 0


initialized = false


CellStore = Object.create EventEmitter::,
  ###
    Projects KeyDownActions into application state.

    if Ticker.ticking()
      updates application state
  ###

  initialize: ->
    if initialized
      throw new Error "Already initialized"
    @_reset()
    dispatcher.register (action) =>
      @_handle_action(action)

  cellmap: ->
    cells

  add_change_listener: (listener) ->
    @addListener CHANGE_EVENT, listener

  _handle_action: (action) ->
    if action.is KeyDownAction
      keycode = action.keycode()

      motion = MOTION_KEYS.get(keycode)
      method = METHOD_KEYS.get(keycode)

      if motion? && not game_over?
        snake.set_motion(motion)
        if not Ticker.ticking()
          Ticker.tick(@_next_tick.bind(@), settings.TICK.interval)
      else if method?
        @[method]()

  _out_of_bounds: ->
    {head_x, head_y} = snake.head()
    Math.min(head_x, head_y) < 0 ||
    Math.max(head_x, head_y) >= settings.GRID.dimension

  _next_tick: ->
    snake.move()
    if (!game_over? || game_over.success) && @_out_of_bounds()
      # prevent infinite recursion with the first condition
      @_on_smash(smashed: Cell.Wall, smasher: Cell.Snake)
    else if game_over?
      @_finish()
    else
      @_update()
    @emit(CHANGE_EVENT, cellmap: cells)

  _reset: ->
    game_over = null
    Items = 0
    snake = Snake.at_position XY.random(settings.GRID.dimension - 1)
    cells.withMutations (mutative_cells) =>
      mutative_cells.forEach (cell, xy) =>
        if snake.meets xy
          mutative_cells.set xy, Cell.Snake
        else
          mutative_cells.set xy, @_get_random_cell(increment: true)
    @emit(CHANGE_EVENT, cellmap: cells)

  _finish: ->
    transform_to_cell = if game_over.success
      Cell.Item
    else
      Cell.Collision

    snake.motion(null)
    snake.rewind()

    Ticker.stop =>
      cells.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if snake.meets(xy)
            mutative_cells.set xy, transform_to_cell

  _update: ->
    cells.withMutations (mutative_cells) ->
      mutative_cells.forEach (cell, xy) ->
        if snake.meets xy
          [smasher, smashed] = [Cell.Snake, cell]
          if smashed isnt Cell.Void
            if smashed is Cell.Item
              mutative_cells.set xy, smasher
            if smashed is Cell.Snake and smasher is Cell.Snake
              if snake.head() is xy
                @_on_smash({smashed, smasher, xy})
            else
              @_on_smash({smashed, smasher, xy})
          else if smashed isnt Cell.Wall
            mutative_cells.set xy, Cell.Snake
        else if cell is Cell.Snake
          mutative_cells.set xy, Cell.Void

  _get_random_cell: (options = {increment: false})->
    cell = Cell.random()
    if cell is Cell.Item && options.increment
      Items ||= 0
      Items += 1
    cell

  __restart: ->
    Ticker.stop =>
      @_reset()
      @emit(CHANGE_EVENT, cellmap: cells)

  _on_smash: ({smashed, smasher, xy}) =>
    if smashed is Cell.Snake and smasher is Cell.Snake and snake.head() is xy
      game_over = game_over.failure
    else if smashed is Cell.Wall
      game_over = game_over.failure
    else if smashed is Cell.Item
      Items--
      if Items is 0
        game_over = game_over.success
      else
        snake.grow()


module.exports = CellStore