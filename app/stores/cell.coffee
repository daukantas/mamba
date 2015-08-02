{KeyDownAction} = require '../actions'
{Ticker, XY, GAME_OVER} = require '../utility'
settings = require '../settings'
Snake = require '../snake'
Cell = require '../views/cell'

Dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'


CHANGE_EVENT = 'change'

INITIALIZED = false

METHOD_KEYMAP = Immutable.Map [
  ['restart', '__restart']
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
      Dispatcher.register (action) =>
        @_handle_action(action)

  cellmap:
    enumerable: true
    value: ->
      cells

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener CHANGE_EVENT, listener

  _handle_action:
    value: (action) ->
      if action.is KeyDownAction
        motion = action.motion()
        method = action.method()

        if motion? && not game_over?
          snake.set_motion(motion)
          if not Ticker.ticking()
            Ticker.tick =>
              @_tick()
            , settings.TICK.interval
        else if method?
          @[METHOD_KEYMAP.get(method)]()

  _tick:
    value: ->
      if (not game_over?) && @_out_of_bounds()
        # prevent infinite recursion with the first condition
        @_collision(Cell.Wall)
      else if game_over?
        @_finish()
      else
        @_update()
      @emit(CHANGE_EVENT, cellmap: cells)

  _reset:
    value: ->
      random_cell = ->
        cell = Cell.random()
        if cell is Cell.Item
          Items_remaining ||= 0
          Items_remaining += 1
        cell

      game_over = null
      Items_remaining = 0

      snake = Snake.at_position XY.random(settings.GRID.dimension - 1)
      cells = cells.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if snake.meets xy
            mutative_cells.set xy, Cell.Snake
          else
            mutative_cells.set xy, random_cell()
      @emit(CHANGE_EVENT, cellmap: cells)

  _finish:
    value: ->
      snake.move(null)

      transform_to_cell = if game_over.success
        Cell.Item
      else
        Cell.Collision

      # rewind one frame so snake doesn't "go through" wall
      (not game_over.success) && snake.rewind()

      Ticker.stop ->
        cells = cells.withMutations (mutative_cells) ->
          mutative_cells.forEach (cell, xy) ->
            if snake.meets(xy)
              mutative_cells.set xy, transform_to_cell

  _update:
    value: ->
      snake.move()

      cells = cells.withMutations (mutative_cells) =>
        mutative_cells.forEach (previous_cell, xy) =>
          if snake.meets xy
            if previous_cell is Cell.Item
              @_collision(Cell.Item)
            else if previous_cell is Cell.Snake
              if snake.head() is xy
                @_collision(Cell.Snake)
            else if previous_cell is Cell.Wall
              @_collision(Cell.Wall)
            mutative_cells.set xy, Cell.Snake
          else if previous_cell is Cell.Snake
            mutative_cells.set xy, Cell.Void

  _collision:
    value: (smashed) ->
      if smashed is Cell.Snake
        game_over = GAME_OVER.failure
      else if smashed is Cell.Wall
        game_over = GAME_OVER.failure
      else if smashed is Cell.Item
        Items_remaining--
        if Items_remaining is 0
          game_over = GAME_OVER.success
        else
          snake.grow()

  __restart:
    value: ->
      Ticker.stop => @_reset()

  _out_of_bounds:
    value: ->
      {head_x, head_y} = snake.head()
      Math.max(head_x, head_y) < 0 ||
      Math.min(head_x, head_y) >= settings.GRID.dimension


module.exports = CellStore