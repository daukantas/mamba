{MotionKeyAction, MethodKeyAction} = require '../actions'
{Ticker, XY, GAME, Random} = require '../utility'
Cell = require '../views/cell'
{GRID, LEVEL} = require '../settings'

Dispatcher = require '../dispatcher'
{EmittingStore} = require './emitter'
Immutable = require 'immutable'

LAST_CELLS = null
LIVE_CELLS = Immutable.OrderedMap().withMutations (mutable_cells) ->
  range = GRID.range()
  for row in range
    for col in range
      mutable_cells.set XY.value_of(row, col), null
  undefined

GridEvolver = Object.create EmittingStore,

  _post_initialize_hook:
    enumerable: false
    value: ->
      @_reset()

  cellmap:
    enumerable: true
    value: ->
      LIVE_CELLS

  add_cells_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_CHANGE_EVENT, listener

  add_score_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_SCORE_EVENT, listener

  _CHANGE_EVENT:
    value: 'change'

  _SCORE_EVENT:
    value: 'score'

  _METHOD_KEYMAP:
    value: Immutable.Map [
      ['restart', '_restart']
    ]

  _handle_action:
    value: (action) ->
      if action.is_a MotionKeyAction
        motion = action.motion()

        if motion? && not GAME.over()
          GAME.set_motion(motion)
          if not Ticker.ticking()
            @_tick()
      else if action.is_a MethodKeyAction
        method = @_METHOD_KEYMAP.get(action.method())
        @[method]()

  _emit_cells:
    value: ->
      @emit(@_CHANGE_EVENT, cellmap: LIVE_CELLS)

  _emit_score:
    value: (ev) ->
      @emit(@_SCORE_EVENT, ev)

  _tick:
    value: ->
      LAST_CELLS = LIVE_CELLS
      @_evolve()

      if GAME.out_of_bounds()
        GAME.track_collision Cell.WALL
      if GAME.should_reset_round()
        @_reset(round: true)
        Ticker.tick => @_tick()
      else if GAME.over()
        @_finish()
      else
        Ticker.tick => @_tick()

      @_emit_cells()

  _reset:
    value: (options = {round: false}) ->
      if options.round
        GAME.reset_round()
      else
        GAME.reset()

      @_shuffled_reset()

      LIVE_CELLS.valueSeq().forEach (cell) ->
        if cell is Cell.ITEM
          GAME.add_item()

      unless options.round
        @_emit_score(reset: true)
        @_emit_cells()

  _finish:
    value: ->
      if GAME.failed()
        transform_to_cell = Cell.COLLISION
        @_rewind()
      else
        transform_to_cell = Cell.ITEM

      @_batch_evolve (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if cell is Cell.SNAKE
            mutable_cells.set xy, transform_to_cell

  _shuffled_reset:
    value: ->
      @_batch_evolve (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if GAME.collides_with xy
            mutable_cells.set xy, Cell.SNAKE
          else
            mutable_cells.set xy, Cell.VOID

      voided_cellmap = LIVE_CELLS.withMutations (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if cell isnt Cell.SNAKE
            mutable_cells.set xy, Cell.VOID

      will_repopulate = Immutable.OrderedMap(voided_cellmap
        .entrySeq()
        .filter((entry) ->
          [xy, cell] = entry
          cell isnt Cell.SNAKE
        )
        .map((entry) -> [entry[0], null]))

      num_walls = LEVEL.get_cell_quantity Cell.WALL
      num_items = LEVEL.get_cell_quantity Cell.ITEM

      # The sequel reasonably assumes this quantity is > 0; if we
      # write down them math, it's probably >> 0.
      num_voids = will_repopulate.size - num_walls - num_items

      # Helper map for random_reset algorithm
      cellcodes = Immutable.Map [
        [Cell.VOID, 0]
        [Cell.WALL, 1]
        [Cell.ITEM, 2]
      ]

      # Max size of this is (GRID.dimension - 1) squared; ~< 900.
      shuffle_profile = (
        cellcodes.get(Cell.WALL) for _ in [0...num_walls]
      ).concat (
        cellcodes.get(Cell.ITEM) for _ in [0...num_items]
      ).concat (
        cellcodes.get(Cell.VOID) for _ in [0...num_voids]
      )

      Random.shuffle(shuffle_profile)

      will_repopulate = will_repopulate.withMutations (mutable_cells) ->
        mutable_cells.keySeq().forEach (xy, index) ->
          mutable_cells.set xy, cellcodes.keyOf(shuffle_profile[index])

      shuffled_cellmap = voided_cellmap.withMutations (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if will_repopulate.has xy
            mutable_cells.set(xy, will_repopulate.get(xy))

      # set up for GC
      shuffle_profile = null
      will_repopulate = null

      LAST_CELLS = null
      LIVE_CELLS = shuffled_cellmap

  _batch_evolve:
    value: (mutator) ->
      LAST_CELLS = LIVE_CELLS
      LIVE_CELLS = LIVE_CELLS.withMutations mutator

  _rewind:
    value: ->
      LIVE_CELLS = LAST_CELLS
      LAST_CELLS = null

  _evolve:
    value: ->
      GAME.move_snake()

      @_batch_evolve (mutable_cells) =>
        mutable_cells.forEach (previous_cell, xy) =>
          if GAME.collides_with xy
            if previous_cell is Cell.VOID
              mutable_cells.set xy, Cell.SNAKE
            else
              if previous_cell is Cell.ITEM
                @_emit_score(increment: true)
                mutable_cells.set xy, Cell.SNAKE
              GAME.track_collision previous_cell, xy
          else if previous_cell is Cell.SNAKE
            mutable_cells.set xy, Cell.VOID

  _restart:
    value: ->
      Ticker.stop => @_reset()


module.exports = GridEvolver