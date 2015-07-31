React = require 'react'

Row = require '../row'
Cell = require '../cell'
{GRID} = require '../settings'

game_over = require '../util/game-over' # can't require the top-level module
Immutable = require 'immutable'

CellStore = require '../../stores'

Grid = React.createClass
  ###
    @state.cellmap is defined by an Immutable.Map of xy-values to Cells.
  ###

  propTypes:
    cellmap: React.PropTypes.oneOf(Immutable.Map)

  statics:
    out_of_bounds: (snake) ->
      head = snake.head()
      head.x < 0 ||
      head.y < 0 ||
      head.x >= GRID.dimension ||
      head.y >= GRID.dimension

  shouldComponentUpdate: (next_props) ->
   if next_props.game_over?
     true
   else if next_props.reset
     true

  getInitialState: ->
    cellmap: @reset(@props, initial: true)

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