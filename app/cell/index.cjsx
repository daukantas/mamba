React = require 'react'
cells = require './types'
{LEVEL} = require '../settings'
Immutable = require 'immutable'

_ = require 'underscore'

Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cells).isRequired
    on_collision: React.PropTypes.func.isRequired
    lost: React.PropTypes.bool.isRequired

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

  _has_wall_collision: (next_props) ->
    (@props.content is cells.Wall) and (next_props.content is cells.Snake)

  componentWillReceiveProps: (next_props) ->
    [
      old_cell
      new_cell
    ] = [
      @props.content
      next_props.content
    ]
    if new_cell is cells.Snake
      if old_cell is cells.Item
        @props.on_collision cells.Item
      else if old_cell is cells.Wall
        @props.on_collision cells.Wall

  shouldComponentUpdate: (next_props, next_state) ->
    next_props.lost || (not @_has_wall_collision(next_props))

  render: ->
    <div className="#{@constructor.classmap.get(@props.content)}"></div>


module.exports = Cell