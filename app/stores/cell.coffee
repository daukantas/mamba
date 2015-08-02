{KeyDownAction} = require '../actions'
{Ticker, XY, GAME} = require '../utility'
Cell = require '../views/cell'
{GRID} = require '../settings'

Dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'

CELLS = Immutable.OrderedMap().withMutations (mutative_cells) ->
  range = GRID.range()
  for row in range
    for col in range
      mutative_cells.set XY.value_of(row, col), null

last_cells = null
INITIALIZED = false

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
      CELLS

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener @CHANGE_EVENT, listener

  CHANGE_EVENT:
    enumerable: true
    value: 'change'

  METHOD_KEYMAP:
    value: Immutable.Map [
      ['restart', '__restart']
    ]

  _handle_action:
    value: (action) ->
      if action.is KeyDownAction
        motion = action.motion()
        method = action.method()

        if motion? && not GAME.game_over()
          GAME.set_motion(motion)
          if not Ticker.ticking()
            @_tick()
        else if method?
          @[@METHOD_KEYMAP.get(method)]()

  _tick:
    value: ->
      last_cells = CELLS
      @_update()

      if GAME.out_of_bounds()
        GAME.collide(Cell.Wall)
      if GAME.game_over()
        @_finish()
      else
        Ticker.tick => @_tick()

      @emit(@CHANGE_EVENT, cellmap: CELLS)

  _reset:
    value: ->
      random_cell = ->
        cell = Cell.random()
        if cell is Cell.Item
          GAME.add_item()
        cell

      GAME.reset()

      CELLS = CELLS.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if GAME.collision xy
            mutative_cells.set xy, Cell.Snake
          else
            mutative_cells.set xy, random_cell()

      @emit(@CHANGE_EVENT, cellmap: CELLS)

  _finish:
    value: ->
      transform_to_cell = if GAME.failed()
        Cell.Collision
      else
        Cell.Item

      if GAME.failed()
        @_rewind()

      CELLS = CELLS.withMutations (mutative_cells) ->
        mutative_cells.forEach (cell, xy) ->
          if cell is Cell.Snake
            mutative_cells.set xy, transform_to_cell

  _rewind:
    value: ->
      CELLS = last_cells
      last_cells = null

  _update:
    value: ->
      GAME.move_snake()

      CELLS = CELLS.withMutations (mutative_cells) =>
        mutative_cells.forEach (previous_cell, xy) =>
          if GAME.collision xy
            if previous_cell is Cell.Void
              mutative_cells.set xy, Cell.Snake
            else
              if previous_cell is Cell.Item
                mutative_cells.set xy, Cell.Snake
              GAME.collide previous_cell, xy
          else if previous_cell is Cell.Snake
            mutative_cells.set xy, Cell.Void

  __restart:
    value: ->
      Ticker.stop => @_reset()


module.exports = CellStore