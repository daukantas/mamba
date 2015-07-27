React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
Snake = require '../snake' # can't require this :(
settings = require '../settings'
position = require '../util/position'
Immutable = require 'immutable'

Row = React.createClass

  propTypes:
    reset: React.PropTypes.bool.isRequired
    snake: React.PropTypes.any.isRequired

    row: React.PropTypes.number.isRequired

    on_reset: React.PropTypes.func.isRequired
    on_smash: React.PropTypes.func.isRequired

  getInitialState: ->
    cells: @reset(@props, initial: true)

  componentWillReceiveProps: (next_props) ->
    if next_props.reset
      @setState cells: @reset(next_props)
    else
      @setState cells: @update(next_props)

  shouldComponentUpdate: (next_props, next_state) ->
    if next_props.reset
      true
    else
      (next_state.cells isnt @state.cells)

  _batch_update: (callback) ->
    unless @state?.cells?
      throw new Error "state.cells doesn't exist"
    @state.cells.withMutations callback

  _create_cells: (props) ->
    if @state?.cells?
      throw new Error "state.cells already exists; use ._batch_update()"
    Immutable.List.of (settings.GRID.range().map (col) =>
      if props.snake.meets position.value_of(props.row, col)
        Cell.Snake
      else
        @_get_random_cell(increment: true))...

  reset: (props, options = {initial: false}) ->
    @_Items_created = 0
    if options.initial
      @_create_cells(props)
    else
      @_batch_update (cells) =>
        cells.forEach (cell, col) =>
          if props.snake.meets position.value_of(props.row, col)
            cells.set col, Cell.Snake
          else
            cells.set col, @_get_random_cell(increment: true)

  update: (props) ->
    @_batch_update (cells) =>
      cells.forEach (cell, col) =>
        if props.snake.meets position.value_of(props.row, col)
          if cell isnt Cell.Void
            if cell is Cell.Item
              cells.set col, Cell.Snake
            props.on_smash(cell)
          else
            cells.set col, Cell.Snake
        else if cell is Cell.Snake
          cells.set col, Cell.Void

  _get_random_cell: (options = {increment: false})->
    cell = Cell.random()
    if cell is Cell.Item && options.increment
      @_Items_created ||= 0
      @_Items_created += 1
    cell

  _submit_Items_created: ->
    @props.on_reset(@_Items_created)

  componentDidUpdate: ->
    if @props.reset
      @_submit_Items_created()

  componentDidMount: ->
    @_submit_Items_created()

  render: ->
    {row} = @props
    <div className="row">
      {@state.cells.map (cell, col) =>
        (<Cell key="cell-#{row}-#{col}" content={cell}/>)}
    </div>


module.exports = Row;