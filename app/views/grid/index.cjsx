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


__Grid__ = null


module.exports = Object.create null,

  _html_element:
    writable: true
    value: ->
      @_html_element

  mount:
    enumerable: true
    value: (@_html_element) ->
      @

  render:
    enumerable: true
    value: ->
      if !@_html_element?
        throw new Error("Set HTMLElement html_element before rendering!")
      else if __Grid__?
        throw new Error("Grid's already been rendered!")
      __Grid__ = React.render <Grid />, @_html_element