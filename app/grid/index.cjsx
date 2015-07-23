React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba'    # can't require this?!
Row = require '../row'
Cell = require '../cell'

xy = require '../util/xy'     # strangely, cannot require util
settings = require '../settings'


DIMENSION = settings.GRID.dimension

Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool
    # mamba: React.PropTypes.instanceOf(Mamba)
    mode: React.PropTypes.objectOf(React.PropTypes.number)


  statics:
    dimension: [0...DIMENSION]

  # TODO:
  #   - if the player isn't close to the row, don't do update
  #   - if reset is true, update and reset
  #   - if an item was consumed, update and reset
  shouldComponentUpdate: (next_props, next_state) ->
    true

  componentWillMount: (props) ->
    @setState rows: @reset_rows()

  componentWillReceiveProps: (props) ->
    if props.reset
      @setState rows: @reset_rows()
    else if props.mamba.moving()
      @setState rows: @update_rows()

  update_rows: ->
    for row in @constructor.dimension
      cells = for col in @constructor.dimension
        if @props.mamba.meets xy.value_of(row, col)
          Cell.Snake
        else
          old_cell = @state.rows[row].props.cells[col]
          if old_cell is Cell.Snake
            Cell.Void
          else
            old_cell
      <Row cells={cells} row={row} key={"row-#{row}"} />

  reset_rows: ->
    for row in @constructor.dimension
      cells = for col in @constructor.dimension
        if @props.mamba.meets xy.value_of(row, col)
          Cell.Snake
        else
          chance = Math.random()
          if chance < @props.mode.wall
            Cell.Wall
          else if chance < @props.mode.item
            Cell.Item
          else
            Cell.Void
      <Row cells={cells} row={row} key={"row-#{row}"} />

  render: ->
    <div className="grid">
      {@state.rows}
    </div>


module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    unless @_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    React.render <Grid {... props}/>, @_html_element