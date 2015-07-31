Snake = require '../snake'
{Keydown} = require '../actions'
{GRID} = require '../settings'
Cell = require '../cell'

dispatcher = require '../dispatcher'
{EventEmitter} = require 'events'
Immutable = require 'immutable'


CellStore = Object.create EventEmitter::,

  should_update: (next_props) ->
    if next_props.game_over?
      true
    else if next_props.reset
      true
    else
      @props.snake.moving()

  componentWillReceiveProps: (next_props) ->
  # Saving this in @state fails; it won't be "ready"
  # in shouldComponentUpdate. Note that this isn't
  # really a Cell.Wall collision - the boundary is
  # artificial.
    if @_no_loss(next_props) && @constructor.out_of_bounds(next_props.snake)
  # prevent infinite recursion using @_no_loss
      @props.on_smash(smashed: Cell.Wall, smasher: Cell.Snake)
    else if next_props.reset
      @setState cellmap: @reset(next_props)
    else if next_props.game_over?
      @setState cellmap: @finish(next_props)
    else
      @setState cellmap: @update(next_props)

  _no_loss: (next_props) ->
    !next_props.game_over? || next_props.game_over.success

  create_cells: (snake) ->
    if @cellmap?
      throw new Error "cellmap already exists; use ._batch_update()"
    dimspan = GRID.range()
    cellmap = Immutable.OrderedMap().withMutations (mutative_cellmap) =>
      for row in dimspan
        for col in dimspan
          xy = position.value_of(row, col)
          cell = if snake.meets xy
            Cell.Snake
          else
            @_get_random_cell(increment: true)
          mutative_cellmap.set xy, cell
    cellmap

  _batch_update: (callback) ->
    unless @state?.cellmap?
      throw new Error "state.cellmap doesn't exist"
    @state.cellmap.withMutations callback

  finish: (next_props) ->
    {game_over, snake} = next_props
    transform_to_cell = if game_over.success
      Cell.Item
    else
      Cell.Collision
    @_batch_update (mutative_cellmap) ->
      mutative_cellmap.forEach (cell, xy) ->
        if snake.meets(xy)
          mutative_cellmap.set xy, transform_to_cell

  reset: (next_props, options = {initial: false}) ->
    {snake} = next_props
    @_Items_created = 0
    if options.initial
      @_create_cellmap(snake)
    else
      @_batch_update (mutative_cellmap) =>
        mutative_cellmap.forEach (cell, xy) =>
          if snake.meets xy
            mutative_cellmap.set xy, Cell.Snake
          else
            mutative_cellmap.set xy, @_get_random_cell(increment: true)

  update: (next_props) ->
    @_batch_update (mutative_cellmap) =>
      @_next_tick(mutative_cellmap, next_props)

  _next_tick: (mutative_cellmap, next_props) ->
    {snake, on_smash} = next_props
    mutative_cellmap.forEach (cell, xy) =>
      if snake.meets xy
        [smasher, smashed] = [Cell.Snake, cell]
        if smashed isnt Cell.Void
          if smashed is Cell.Item
            mutative_cellmap.set xy, smasher
          if smashed is Cell.Snake and smasher is Cell.Snake
            if snake.head() is xy
              on_smash({smashed, smasher, xy})
          else
            on_smash({smashed, smasher, xy})
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


dispatcher.register (action) ->
  if action.is Keydown
    return
  keycode = action.keycode()