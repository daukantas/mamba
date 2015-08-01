React = require 'react'
Row = require '../row'
{GRID} = require '../settings'

CellStore = require '../../stores'


Grid = React.createClass

  getInitialState: ->
    cellmap: CellStore.cellmap()

  componentDidMount: ->
    CellStore.add_change_listener @_on_change

  _on_change: ->
    @setState(cellmap: CellStore.cellmap())

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