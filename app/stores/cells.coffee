{MotionKeyAction, MethodKeyAction} = require '../actions'
{Ticker, XY, GAME} = require '../utility'
Cell = require '../views/cell'
{GRID} = require '../settings'

Dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'

LAST_CELLS = null
LIVE_CELLS = Immutable.OrderedMap().withMutations (mutable_cells) ->
  range = GRID.range()
  for row in range
    for col in range
      mutable_cells.set XY.value_of(row, col), null

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
      LIVE_CELLS

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_CHANGE_EVENT, listener

  _CHANGE_EVENT:
    value: 'change'

  _METHOD_KEYMAP:
    value: Immutable.Map [
      ['restart', '_restart']
    ]

  _handle_action:
    value: (action) ->
      if action.is MotionKeyAction
        motion = action.motion()

        if motion? && not GAME.over()
          GAME.set_motion(motion)
          if not Ticker.ticking()
            @_tick()
      else if action.is MethodKeyAction
        method = @_METHOD_KEYMAP.get(action.method())
        @[method]()

  _emit_cells:
    value: ->
      @emit(@_CHANGE_EVENT, cellmap: LIVE_CELLS)

  _tick:
    value: ->
      LAST_CELLS = LIVE_CELLS
      @_update()

      if GAME.out_of_bounds()
        GAME.collide Cell.Wall
      if GAME.over()
        @_finish()
      else
        Ticker.tick => @_tick()

      @_emit_cells()

  _reset:
    value: ->
      random_cell = ->
        cell = Cell.random()
        if cell is Cell.Item
          GAME.add_item()
        cell

      GAME.reset()

      @_batch_mutate (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if GAME.collision xy
            mutable_cells.set xy, Cell.Snake
          else
            mutable_cells.set xy, random_cell()

      @_emit_cells()

  _finish:
    value: ->
      if GAME.failed()
        transform_to_cell = Cell.Collision
        @_rewind()
      else
        transform_to_cell = Cell.Item

      @_batch_mutate (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if cell is Cell.Snake
            mutable_cells.set xy, transform_to_cell

  _batch_mutate:
    value: (mutator) ->
      LIVE_CELLS = LIVE_CELLS.withMutations mutator

  _rewind:
    value: ->
      LIVE_CELLS = LAST_CELLS
      LAST_CELLS = null

  _update:
    value: ->
      GAME.move_snake()

      @_batch_mutate (mutable_cells) =>
        mutable_cells.forEach (previous_cell, xy) =>
          if GAME.collision xy
            if previous_cell is Cell.Void
              mutable_cells.set xy, Cell.Snake
            else
              if previous_cell is Cell.Item
                mutable_cells.set xy, Cell.Snake
              GAME.collide previous_cell, xy
          else if previous_cell is Cell.Snake
            mutable_cells.set xy, Cell.Void

  _restart:
    value: ->
      Ticker.stop => @_reset()


module.exports = CellStore