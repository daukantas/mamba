React = require 'react'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup


Keys = require './types'
_ = require 'underscore'

Key = React.createClass

  propTypes:
    pressed: React.PropTypes.bool.isRequired
    keytype: React.PropTypes.oneOf(_.values Keys).isRequired
    label: React.PropTypes.string

  render: ->
    [keyname_class, pressed_class] = [
      "#{@props.keytype.shortname()}-key"
      (@props.pressed && 'pressed') || ''
    ]

    <ReactCSSTransitionGroup transitionName='fading-in' transitionAppear={true}>
      {if @props.label?
        <div className="controls-key-label #{keyname_class}">{@props.label}</div>
      }
      <div className="controls-key #{keyname_class} #{pressed_class}">
        {@props.keytype.symbol()}
      </div>
    </ReactCSSTransitionGroup>


module.exports = Key