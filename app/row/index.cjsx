React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
Snake = require '../snake' # can't require this :(
settings = require '../settings'

position = require '../util/position'
game_over = require '../util/game-over' # again, can't require the top-level module

Immutable = require 'immutable'

Row = React.createClass

  propTypes:
    cells: React.PropTypes.objectOf(Immutable.Iterable)
    smash: React.PropTypes.func.isRequired
    index: React.PropTypes.number.isRequired

  shouldComponentUpdate: (next_props) ->
    if next_props.reset
      true
    else
      (next_props.cells isnt @props.cells)

  render: ->
    <div className="row">
      {@state.cells.map (cell, col) =>
        (<Cell key="cell-#{@props.index}-#{col}" content={cell}/>)}
    </div>


module.exports = Row;