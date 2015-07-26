React = require 'react'
cells = require './types'
{LEVEL} = require '../settings'
Immutable = require 'immutable'

_ = require 'underscore'

Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cells).isRequired
    on_collision: React.PropTypes.func.isRequired

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
      choice = LEVEL.choice(cells.Wall, cells.Item)
      (choice? && choice) || @Void

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
        @props.on_collision cells.Item
      else if old_cell is cells.Wall
        @props.on_collision cells.Wall
        @setState collided: true

  render: ->
    content = ((@state?.collided is true) && cells.Wall) || @props.content

    <div className="#{@constructor.classmap.get(content)}"></div>


module.exports = Cell