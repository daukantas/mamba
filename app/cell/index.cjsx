React = require 'react'
cell_types = require './types'
{LEVEL} = require '../settings'
Random = require '../util/random' # can't require util
Immutable = require 'immutable'

_ = require 'underscore'


Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cell_types).isRequired

  statics: _.extend {}, cell_types
  , type_classmap: (content) ->
      if content is @Item
        'item-cell'
      else if content is @Void
        'void-cell'
      else if content is @Wall
        'wall-cell'
      else if content is @Snake
        'snake-cell'

  , random: ->
    sample = Random.int(0, 100)
    if LEVEL.get(@Wall).contains(sample)
      @Wall
    else if LEVEL.get(@Item).contains(sample)
      @Item
    else
      @Void

  render: ->
    content_class = @constructor.type_classmap(@props.content)

    <div className="#{content_class}"></div>


module.exports = Cell