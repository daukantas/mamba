React = require 'react'
cell_types = require './types'

_ = require 'underscore'


statics = _.extend {}, cell_types, type_classmap: (content) ->
  if content is @Grub
    'grub-cell'
  else if content is @Void
    'void-cell'
  else if content is @Wall
    'wall-cell'
  else if content is @Snake
    'snake-cell'


Cell = React.createClass

  propTypes:
    content: React.PropTypes.oneOf(_.values cell_types).isRequired

  statics: statics

  render: ->
    content_class = @constructor.type_classmap(@props.content)

    <div className="cell #{content_class}">Cell</div>


module.exports = {Cell}