React = require 'react'
_ = require 'underscore'

Cell = require '../cell'
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
    row = @props.index
    <div className="row">
      {@props.cells.map (cell, col) ->
        (<Cell key="cell-#{row}-#{col}" content={cell}/>)}
    </div>


module.exports = Row;