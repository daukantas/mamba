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

  componentWillReceiveProps: (next_props) ->
    @setState reset: !!next_props.reset

  # TODO:
  #   - if the player isn't close to the row, don't do update
  #   - if reset is true, update and reset
  #   - if an item was consumed, update and reset
  shouldComponentUpdate: (next_props, next_state) ->
    true

  row_cells: (row) ->
    _.times(DIMENSION, (column) ->
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
    rows = _.times(DIMENSION, (row) ->
      <Row cells={@row_cells(row)} row={row} key={"row-#{row}"} />
    , @)

    <div className="grid">{rows}</div>


module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    unless @_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    React.render <Grid {... props}/>, @_html_element