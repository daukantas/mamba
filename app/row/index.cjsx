React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
Mamba = require '../mamba' # can't require this!
settings = require '../settings'
xy = require '../util/xy'

Row = React.createClass

  shouldComponentUpdate: (next_props, next_state)->
    true

  propTypes:
    mamba: React.PropTypes.any.isRequired
    reset: React.PropTypes.bool.isRequired
    mode: React.PropTypes.objectOf(React.PropTypes.number)
    row: React.PropTypes.number.isRequired

  componentWillMount: ->
    @setState cells: @reset(@props)

  componentWillReceiveProps: (next_props) ->
    if next_props.reset
      @setState cells: @reset(next_props)
    else
      @setState cells: @update(next_props)

  reset: (props) ->
    for col in settings.GRID.range()
      if props.mamba.meets xy.value_of(props.row, col)
        Cell.Snake
      else
        chance = Math.random()
        if chance < @props.mode.wall
          Cell.Wall
        else if chance < @props.mode.item
          Cell.Item
        else
          Cell.Void

  update: (props) ->
    for cell, col in @state.cells
      if props.mamba.meets xy.value_of(props.row, col)
        Cell.Snake
      else
        ((cell is Cell.Snake) && Cell.Void) || cell

  render: ->
    <div className="row">
      {(<Cell key="cell-#{@props.row}-#{col}"} content={cell}/> for cell, col in @state.cells)}
    </div>


module.exports = Row;