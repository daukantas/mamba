React = require 'react'
cell_types = require './types'

_ = require 'underscore'


Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cell_types).isRequired

  statics: _.extend {}, cell_types, type_classmap: (content) ->
     if content is @Item
       'item-cell'
     else if content is @Void
       'void-cell'
     else if content is @Wall
       'wall-cell'
     else if content is @Snake
       'snake-cell'

  render: ->
    content_class = @constructor.type_classmap(@props.content)

    <div className="cell #{content_class}">Cell</div>


module.exports = {Cell}