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
    @setState cells: @reset(@props, initial: true)

  componentWillReceiveProps: (next_props) ->
    if next_props.reset
      @setState cells: @reset(next_props)
    else
      @setState cells: @update(next_props)

  shouldComponentUpdate: (next_props, next_state) ->
    next_props.reset or (not next_state.cells.equals @state.cells)

  _update_cells: (callback) ->
    unless @state?.cells?
      throw new Error "state.cells doesn't exist"
    @state.cells.withMutations callback

  _create_cells: (props) ->
    if @state?.cells?
      throw new Error "state.cells already exists; use ._update_cells()"
    Immutable.List.of (for col in settings.GRID.range()
      if props.mamba.meets position.value_of(props.row, col)
        Cell.Snake
      else
        @_random_cell(props.mode))...

  reset: (props, options = {initial: false}) ->
    if options.initial
      @_create_cells(props)
    else
      @_update_cells (cells) =>
        cells.forEach (cell, col) =>
          if props.mamba.meets position.value_of(props.row, col)
            cells.set(col, Cell.Snake)
          else
            cells.set(col, @_random_cell(props.mode))

  update: (props) ->
    @_update_cells (cells) =>
      cells.forEach (cell, col) =>
        if props.mamba.meets(position.value_of(props.row, col))
          if cell isnt Cell.Void
            @props.collision(cell, props.row, col)
          cells.set(col, Cell.Snake)
        else if cell is Cell.Snake
          cells.set(col, Cell.Void)

  _random_cell: (mode) ->
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