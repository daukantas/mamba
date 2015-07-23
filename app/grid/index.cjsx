React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba'
Row = require '../row'
Cell = require '../cell'
settings = require '../settings'


DIMENSION = settings.GRID.dimension


Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool
    mamba: React.PropTypes.instanceOf(Mamba)
    mode: React.PropTypes.objectOf(React.PropTypes.number)

  # TODO:
  #   - if the player isn't close to the row, don't do update
  #   - if reset is true, update and reset
  #   - if an item was consumed, update and reset
  shouldComponentUpdate: (next_props, next_state) ->
    true

  componentWillMount: (props) ->
    @setState rows: @refresh_rows()

  componentWillReceiveProps: (props) ->
    if props.reset
      @setState rows: @refresh_rows()

  refresh_rows: ->
    for row in [0...DIMENSION]
      cells = for col in [0...DIMENSION]
        # TODO: use a data structure with a fast 'in' operator
        if @props.mamba.meets({x: row, y: col})
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