Snake = require '../snake'
{KeyDownAction, KeySender} = require '../actions'
settings = require '../settings'
Cell = require '../cell'
Grid = require '../views/grid'

dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'
{Ticker, xy} = require '../utility'


CHANGE_EVENT = 'change'

MOTION_KEYS =
  37: xy.value_of(0, -1)  # L
  38: xy.value_of(-1, 0)  # U
  39: xy.value_of(0, +1)  # R
  40: xy.value_of(+1, 0)  # D

METHOD_KEYS =
  82: '__restart'


CellStore = Object.create EventEmitter::,
  ###
    Projects KeyDownActions into application state.

    if Ticker.ticking()
      updates application state
  ###

  _cellmap: null
  _game_over: null
  _snake: null

  initialize: (html_element) ->
    @_make_snake()
    @_make_cells()

    Grid
    .html_element(html_element)
    .render props

    dispatcher.register (action) =>
      @_handle_action(action)

  cellmap: ->
    @_cellmap

  add_change_listener: (listener) ->
    this.addListener CHANGE_EVENT, listener

  _make_snake: ->
    @_snake = Snake.at_position(
      position.random(settings.GRID.dimension - 1))

  _handle_action: (action) ->
    if action.is KeyDownAction
      keycode = action.keycode()
      motion = MOTION_KEYS[keycode]
      method = METHOD_KEYS[keycode]
      if motion && !@_game_over?
        @_snake.set_motion(motion)
        if !Ticker.ticking()
          Ticker.tick =>
            @_next_tick()
          , settings.TICK.interval
      else if method?
        @[method]()

  _out_of_bounds: ->
    {head_x, head_y} = @_snake.head()
    Math.min(head_x, head_y) < 0 ||
    Math.max(head_x, head_y) >= settings.GRID.dimension

  _next_tick: ->
    @_snake.move()
    if @_lost() && @_out_of_bounds()
      # prevent infinite recursion using @_lost
      @_on_smash(smashed: Cell.Wall, smasher: Cell.Snake)
    else if @_game_over?
      @_finish()
    else
      @_update()
    @emit(CHANGE_EVENT, cellmap: @_cellmap)

  _lost: ->
    !@_game_over? || @_game_over.success

  _make_cells: ->
    if @_cellmap?
      throw new Error "cellmap already exists; use ._batch_update()"
    dimspan = settings.GRID.range()
    cellmap = Immutable.OrderedMap().withMutations (mutative_cellmap) =>
      for row in dimspan
        for col in dimspan
          xy = position.value_of(row, col)
          cell = if @_snake.meets xy
            Cell.Snake
          else
            @_get_random_cell(increment: true)
          mutative_cellmap.set xy, cell
    @_cellmap = cellmap

  _batch_update: (callback) ->
    unless @_cellmap?
      throw new Error "this.cellmap doesn't exist"
    @_cellmap.withMutations callback

  _finish: ->
    transform_to_cell = if @_game_over.success
      Cell.Item
    else
      Cell.Collision
    @_batch_update (mutative_cellmap) =>
      mutative_cellmap.forEach (cell, xy) =>
        if @_snake.meets(xy)
          mutative_cellmap.set xy, transform_to_cell
    @_snake.motion(null)
    Ticker.stop =>
      setTimeout =>
        @_snake.rewind()
        @_renderer.update(@_renderprops())
      , settings.TICK.interval

  reset: (options = {initial: false}) ->
    @_Items_created = 0
    if options.initial
      @_make_cells(@_snake)
    else
      @_batch_update (mutative_cellmap) =>
        mutative_cellmap.forEach (cell, xy) =>
          if @_snake.meets xy
            mutative_cellmap.set xy, Cell.Snake
          else
            mutative_cellmap.set xy, @_get_random_cell(increment: true)

  _update: ->
    @_batch_update (mutative_cellmap) =>
      mutative_cellmap.forEach (cell, xy) =>
        if @_snake.meets xy
          [smasher, smashed] = [Cell.Snake, cell]
          if smashed isnt Cell.Void
            if smashed is Cell.Item
              mutative_cellmap.set xy, smasher
            if smashed is Cell.Snake and smasher is Cell.Snake
              if @_snake.head() is xy
                @_on_smash({smashed, smasher, xy})
            else
              @_on_smash({smashed, smasher, xy})
          else if smashed isnt Cell.Wall
            mutative_cellmap.set xy, Cell.Snake
        else if cell is Cell.Snake
          mutative_cellmap.set xy, Cell.Void

  _get_random_cell: (options = {increment: false})->
    cell = Cell.random()
    if cell is Cell.Item && options.increment
      @_Items_created ||= 0
      @_Items_created += 1
    cell

  __restart: ->
    @_game_over = null
    @_make_snake()
    @_make_cells()
    Ticker.stop =>
      @emit(CHANGE_EVENT, cellmap: @_cellmap)

  _on_reset: (@_Items_left) =>

  _on_smash: ({smashed, smasher, xy}) =>
    if smashed is Cell.Snake and smasher is Cell.Snake and @_snake.head() is xy
      @_game_over = game_over.failure
    else if smashed is Cell.Wall
      @_game_over = game_over.failure
    else if smashed is Cell.Item
      @_Items_left--
      if @_Items_left is 0
        @_game_over = game_over.success
      else
        @_snake.grow()


module.exports = CellStore