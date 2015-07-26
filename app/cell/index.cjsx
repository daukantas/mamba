React = require 'react'
cells = require './types'
{LEVEL} = require '../settings'
Random = require '../util/random' # can't require util
Immutable = require 'immutable'

_ = require 'underscore'

Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cells).isRequired
    collided: React.PropTypes.func.isRequired

  statics: _.extend {}, cells
  , classmap: Immutable.Map([
      [
        cells.Item
        'item-cell'
      ]
      [
        cells.Void
        'void-cell'
      ]
      [
        cells.Wall
        'wall-cell'
      ]
      [
        cells.Snake
        'snake-cell'
      ]
      [
        cells.Collision
        'collision-cell'
      ]
    ])

  , random: ->
    sample = Random.int(0, 100)
    if LEVEL.get(@Wall).contains(sample)
      @Wall
    else if LEVEL.get(@Item).contains(sample)
      @Item
    else
      @Void

  componentWillReceiveProps: (next_props) ->
    [
      old_cell
      new_cell
    ] = [
      @props.content
      next_props.content
    ]
    if new_cell is Cell.Snake
      if old_cell is cells.Item
        @props.collided cells.Item
    else if new_cell is Cell.Collision
      @props.collided cells.Collision

  render: ->
    <div className="#{@constructor.classmap.get(@props.content)}"></div>


module.exports = Cell