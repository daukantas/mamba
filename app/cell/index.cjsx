React = require 'react'
cells = require './types'
{LEVEL} = require '../settings'
Immutable = require 'immutable'

_ = require 'underscore'

Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cells).isRequired
    on_collision: React.PropTypes.func.isRequired
    lost: React.PropTypes.oneOf([true, false, null]).isRequired

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

  render: ->
    <div className="#{@constructor.classmap.get(@props.content)}"></div>


module.exports = Cell