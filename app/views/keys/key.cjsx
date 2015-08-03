React = require 'react'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup


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

    <ReactCSSTransitionGroup transitionName='row' transitionAppear={true}>
      <div className="controls-key #{keyname_class} #{pressed_class}">
        {@props.keytype.symbol()}
      </div>
    </ReactCSSTransitionGroup>


module.exports = Key