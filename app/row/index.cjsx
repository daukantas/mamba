React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
Mamba = require '../mamba' # can't require this!
settings = require '../settings'
position = require '../util/position'
Immutable = require 'immutable'

Row = React.createClass

  propTypes:
    reset: React.PropTypes.bool.isRequired
    mamba: React.PropTypes.any.isRequired
    mode: React.PropTypes.objectOf(React.PropTypes.number).isRequired
    collision: React.PropTypes.func.isRequired

    row: React.PropTypes.number.isRequired

  componentWillMount: ->
    @setState cells: @reset(@props)

  componentWillReceiveProps: (next_props) ->
    if next_props.reset
      @setState cells: @reset(next_props)
    else
      @setState cells: @update(next_props)

  shouldComponentUpdate: (next_props, next_state) ->
    if next_props.reset
      return true
    !next_state.cells.equals(@state.cells)

  reset: (props) ->
    if @state?.cells?
      @state.cells.withMutations (cells) =>
        cells.forEach (cell, col) =>
          if props.mamba.meets position.value_of(props.row, col)
            cells.set(col, Cell.Snake)
          else
            cells.set(col, @random_cell(props.mode))
    else
      cells = (for col in settings.GRID.range()
        if props.mamba.meets position.value_of(props.row, col)
          Cell.Snake
        else
          @random_cell(props.mode))
      Immutable.List.of(cells...)

  update: (props) ->
    @state.cells.withMutations (cells) =>
      cells.forEach (cell, col) =>
        if props.mamba.meets(position.value_of(props.row, col))
          if cell isnt Cell.Void
            @props.collision(cell, props.row, col)
          cells.set(col, Cell.Snake)
        else if cell is Cell.Snake
          cells.set(col, Cell.Void)

  random_cell: (mode) ->
    random = Math.random()
    if random < mode.wall
      Cell.Wall
    else if random < mode.item
      Cell.Item
    else
      Cell.Void

  render: ->
    <div className="row">
      {@state.cells.map (cell, col) =>
        (<Cell key="cell-#{@props.row}-#{col}"} content={cell}/>)
      }
    </div>


module.exports = Row;