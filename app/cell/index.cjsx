React = require 'react'
cell_types = require './types'
{MODE} = require '../settings'

_ = require 'underscore'


Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cell_types).isRequired

  statics: _.extend {}, cell_types,
    type_classmap: (content) ->
      if content is @Item
        'item-cell'
      else if content is @Void
        'void-cell'
      else if content is @Wall
        'wall-cell'
      else if content is @Snake
        'snake-cell'
  , random: ->
      chance = Math.random()
      if chance < MODE.wall
        Cell.Wall
      else if chance < MODE.item
        Cell.Item
      else
        Cell.Void

  render: ->
    content_class = @constructor.type_classmap(@props.content)

    <div className="#{content_class}"></div>


module.exports = Cell