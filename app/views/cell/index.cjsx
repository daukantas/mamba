React = require 'react'
cells = require './types'
{LEVEL} = require '../../settings'
Immutable = require 'immutable'

_ = require 'underscore'

Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cells).isRequired

  statics: _.extend {}, cells
  , classmap: Immutable.Map([
      [
        cells.ITEM
        'item-cell'
      ]
      [
        cells.VOID
        'void-cell'
      ]
      [
        cells.WALL
        'wall-cell'
      ]
      [
        cells.SNAKE
        'snake-cell'
      ]
      [
        cells.COLLISION
        'collision-cell'
      ]
    ])

  , random: ->
      choice = LEVEL.choose(cells.WALL, cells.ITEM)
      (choice? && choice) || @VOID

  render: ->
    <div className="#{@constructor.classmap.get(@props.content)}"></div>


module.exports = Cell