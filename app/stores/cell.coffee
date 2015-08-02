{KeyDownAction} = require '../actions'
{Ticker, XY, GAME_OVER} = require '../utility'
settings = require '../settings'
Snake = require '../snake'
Cell = require '../views/cell'

dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'


CHANGE_EVENT = 'change'

INITIALIZED = false

MOTION_KEYS = Immutable.Map [
  [
    37
    XY.LEFT()
  ]
  [
    38
    XY.UP()
  ]
  [
    39
    XY.RIGHT()
  ]
  [
    40
    XY.DOWN()
  ]
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
Items_remaining = 0

CellStore_props =

CellStore = Object.create EventEmitter::,

  initialize:
    enumerable: true
    value: ->
      if INITIALIZED
        throw new Error "CellStore already initialized"
      @_reset()
      dispatcher.register (action) =>
        @_handle_action(action)

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener CHANGE_EVENT, listener

  _handle_action:
    value: (action) ->
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

  _out_of_bounds:
    value: ->
      {head_x, head_y} = snake.head()
      Math.min(head_x, head_y) < 0 ||
      Math.max(head_x, head_y) >= settings.GRID.dimension

  _next_tick:
    value: ->
      snake.move()
      if (!game_over? || game_over.success) && @_out_of_bounds()
        # prevent infinite recursion with the first condition
        @_smash(smashed: Cell.Wall, smasher: Cell.Snake)
      else if game_over?
        @_finish()
      else
        @_update()
      @emit(CHANGE_EVENT, cellmap: cells)

  _reset:
    value: ->
      random_cell_with_increment = ->
        cell = Cell.random()
        if cell is Cell.Item
          Items_remaining ||= 0
          Items_remaining += 1
        cell

      game_over = null
      Items_remaining = 0
      snake = Snake.at_position XY.random(settings.GRID.dimension - 1)

      cells.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if snake.meets xy
            mutative_cells.set xy, Cell.Snake
          else
            mutative_cells.set xy, random_cell_with_increment()
      @emit(CHANGE_EVENT, cellmap: cells)

  _finish:
    value: ->
      transform_to_cell = if game_over.success
        Cell.Item
      else
        Cell.Collision

      snake.motion(null)
      snake.rewind() # rewind one frame so snake doesn't "go through" wall

      Ticker.stop ->
        cells.withMutations (mutative_cells) ->
          mutative_cells.forEach (cell, xy) ->
            if snake.meets(xy)
              mutative_cells.set xy, transform_to_cell

  _update:
    value: ->
      cells.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if snake.meets xy
            [smasher, smashed] = [Cell.Snake, cell]
            if smashed isnt Cell.Void
              if smashed is Cell.Item
                mutative_cells.set xy, smasher
              if smashed is Cell.Snake and smasher is Cell.Snake
                if snake.head() is xy
                  @_smash({smashed, smasher, xy})
              else
                @_smash({smashed, smasher, xy})
            else if smashed isnt Cell.Wall
              mutative_cells.set xy, Cell.Snake
          else if cell is Cell.Snake
            mutative_cells.set xy, Cell.Void

  __restart:
    value: ->
      Ticker.stop => @reset()

  _smash:
    value: ({smashed, smasher, xy}) ->
      if smashed is Cell.Snake and smasher is Cell.Snake and snake.head() is xy
        game_over = GAME_OVER.failure
      else if smashed is Cell.Wall
        game_over = GAME_OVER.failure
      else if smashed is Cell.Item
        Items_remaining--
        if Items_remaining is 0
          game_over = GAME_OVER.success
        else
          snake.grow()

module.exports = CellStore