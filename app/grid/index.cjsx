React = require 'react'
_ = require 'underscore'

Snake = require '../snake' # can't require this :(
Row = require '../row'
Cell = require '../cell'
{GRID} = require '../settings'

game_over = require '../util/game-over' # can't require the top-level module
position = require '../util/position'   # can't require the top-level module

Immutable = require 'immutable'


Grid = React.createClass
  ###
    @state.cellmap is defined by an Immutable.Map of xy-values to Cells.
  ###

  propTypes:
    reset: React.PropTypes.bool.isRequired
    snake: React.PropTypes.any.isRequired

    game_over: React.PropTypes.oneOf([
      game_over.failure
      game_over.success
    ])

    on_smash: React.PropTypes.func.isRequired
    on_reset: React.PropTypes.func.isRequired

  statics:
    out_of_bounds: (snake) ->
      head = snake.head()
      head.x < 0 ||
      head.y < 0 ||
      head.x >= GRID.dimension ||
      head.y >= GRID.dimension

  getInitialState: ->
    cellmap: @reset(@props.snake, initial: true)

  shouldComponentUpdate: (next_props) ->
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
      @props.on_smash(smashed: Cell.Wall, smasher: Cell.Snake)
    else if next_props.reset
      @setState cellmap: @reset(next_props.snake)
    else if next_props.game_over?
      @setState cellmap: @finish(next_props)
    else
      @setState cellmap: @update(next_props)

  _batch_update: (callback) ->
    unless @state?.cellmap?
      throw new Error "state.cellmap doesn't exist"
    @state.cellmap.withMutations callback

  finish: (next_props) ->
    transform_to_cell = if next_props.game_over.success
      Cell.Item
    else
      Cell.Collision
    @_batch_update (mutative_cellmap) ->
      mutative_cellmap.forEach (cell, xy) ->
        if cell is Cell.Snake
          mutative_cellmap.set xy, transform_to_cell

  _create_cellmap: (snake) ->
    if @state?.cellmap?
      throw new Error "state.cells already exists; use ._batch_update()"
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

  reset: (snake, options = {initial: false}) ->
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

  _no_loss: (next_props) ->
    !next_props.game_over? || next_props.game_over.success

  componentDidUpdate: ->
    if @props.reset
      @_submit_total_Items()

  componentDidMount: ->
    @_submit_total_Items()

  _submit_total_Items: ->
    @props.on_reset(@_Items_created)

  _get_row_cells: (row) ->
    @state
    .cellmap
    .filter (cell, xy) ->
      xy.x is row
    .valueSeq()
    .toJS()

  render: ->
    <div className="grid">
      {for row in GRID.range()
        <Row cells={@_get_row_cells(row)} index={row}key={"row-#{row}"} />}
    </div>


__GRID__ = null

module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if __GRID__?
      throw new Error("Grid's already been rendered!")
    __GRID__ = React.render <Grid {... props}/>, @_html_element

  # This is supposed to be an anti-pattern, but I
  # don't find it difficult to reason about.
  #
  # https://facebook.github.io/react/docs/component-api.html
  set_props: (props, callback) ->
    if !__GRID__?
      throw new Error("Grid hasn't been rendered!")
    __GRID__.setProps(props, callback)