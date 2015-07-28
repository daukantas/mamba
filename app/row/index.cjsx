React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
Immutable = require 'immutable'

Row = React.createClass
  ###
    Has an Immutable.List of Cells in @state, set from @props.
    Immutability is used for faster change-tracking in shouldComponentUpdate.
  ###

  propTypes:
    cells: React.PropTypes.array.isRequired
    index: React.PropTypes.number.isRequired

  componentWillMount: ->
    @setState cells: Immutable.List(@props.cells)

  componentWillReceiveProps: (next_props, next_state) ->
    @setState cells: @state.cells.withMutations (mutative_cells) ->
      mutative_cells.forEach (old_cell, col) ->
        new_cell = next_props.cells[col]
        if old_cell isnt new_cell
          mutative_cells.set col, new_cell

  shouldComponentUpdate: (next_props, next_state) ->
    if next_props.reset
      true
    else
      (next_state.cells isnt @state.cells)

  render: ->
    row = @props.index
    <div className="row">
      {@state.cells.map (cell, col) ->
        (<Cell key="cell-#{row}-#{col}" content={cell}/>)}
    </div>


module.exports = Row;