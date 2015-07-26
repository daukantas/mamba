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

    on_collision: React.PropTypes.func.isRequired

  componentWillMount: ->
    @setState(cells: @reset(@props, initial: true))

  componentWillReceiveProps: (next_props) ->
    if next_props.reset
      @setState cells: @reset next_props
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
    Immutable.List.of (for col in settings.GRID.range()
      if props.snake.meets position.value_of(props.row, col)
        Cell.Snake
      else
        Cell.random())...

  reset: (props, options = {initial: false}) ->
    if options.initial
      @_create_cells(props)
    else
      @_batch_update (cells) =>
        cells.forEach (cell, col) =>
          if props.snake.meets position.value_of(props.row, col)
            cells.set col, Cell.Snake
          else
            cells.set col, Cell.random()

  update: (props) ->
    @_batch_update (cells) =>
      cells.forEach (cell, col) =>
        if props.snake.meets position.value_of(props.row, col)
          if cell isnt Cell.Void
            if cell is Cell.Item
              cells.set col, Cell.Snake
            props.on_collision(cell)
          else
            cells.set col, Cell.Snake
        else if cell is Cell.Snake
          cells.set col, Cell.Void

  render: ->
    {row, lost} = @props
    <div className="row">
      {@state.cells.map (cell, col) =>
        (<Cell lost={lost} key="cell-#{row}-#{col}" content={cell}/>)}
    </div>


module.exports = Row;