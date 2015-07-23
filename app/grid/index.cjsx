React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba'
Row = require '../row'
Cell = require '../cell'
settings = require '../settings'


DIM = settings.GRID.dimension


Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool
    mamba: React.PropTypes.instanceOf(Mamba)
    mode: React.PropTypes.objectOf(React.PropTypes.number)

  componentWillReceiveProps: (next_props) ->
    @setState reset: !!next_props.reset

  # TODO:
  #   - if the player isn't close to the row, don't do update
  #   - if reset is true, update and reset
  #   - if an item was consumed, update and reset
  shouldComponentUpdate: (next_props, next_state) ->
    true

  cells: (row) ->
    _.times(DIM, (column) ->
      # TODO: use a data structure with a fast 'in' operator
      if _.isEqual(@props.mamba.head(), {x: row, y: column})
        return Cell.Snake

      chance = Math.random()

      if chance < @props.mode.wall
        Cell.Wall
      else if chance < @props.mode.item
        Cell.Item
      else
        Cell.Void
    , @)

  render: ->
    <div className="grid">
      {(<Row cells={@cells(row)} row={row} key={"row-#{row}"} /> for row in [0..DIM])}
    </div>


module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    unless @_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    React.render <Grid {... props}/>, @_html_element