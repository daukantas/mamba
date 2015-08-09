React = require 'react'
Row = require '../row'

{GRID} = require '../../settings'
{GridEvolver} = require '../../stores'


Grid = React.createClass

  getInitialState: ->
    cellmap: GridEvolver.cellmap()

  componentDidMount: ->
    GridEvolver.add_cells_listener @_on_change

  _on_change: ->
    @setState cellmap: GridEvolver.cellmap()

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
        <Row cells={@_get_row_cells(row)} index={row} key={"row-#{row}"} />}
    </div>


{wrap} = require '../wrapper'

module.exports = wrap(<Grid />)