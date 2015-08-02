React = require 'react'
Keys = require './types'
_ = require 'underscore'

Key = React.createClass

  propTypes:
    pressed: React.PropTypes.bool.isRequired
    keytype: React.PropTypes.oneOf(_.values Keys).isRequired

  render: ->
    [keyname_class, pressed_class] = [
      "#{@props.keytype.shortname()}-key"
      (@props.pressed && 'pressed') || ''
    ]

    <div className="controls-key #{keyname_class} #{pressed_class}">
      {@props.keytype.symbol()}
    </div>


module.exports = Key