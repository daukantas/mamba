React = require 'react'
{CellStore} = require '../../stores'
Keys = require './keys'

_ = require 'underscore'


Key = React.createClass

  propTypes:
    pressed: React.PropTypes.bool.isRequired
    keytype: React.PropTypes.oneOf(_.values Keys).isRequired

  render: ->
    console.log "Rendering #{@props.keytype.symbol()}"
    pressed_class = (@props.pressed && 'pressed') || ''

    <div className="controls-key #{@props.keytype.shortname()} #{pressed_class}">
      {@props.keytype.symbol()}
    </div>


Controls = React.createClass

  render: ->
    <div className="key-controls">
      <div class='key-section'></div>
      <Key pressed={true} keytype={Keys.R}></Key>
      <Key pressed={true} keytype={Keys.LEFT}></Key>
      <Key pressed={true} keytype={Keys.UP}></Key>
      <Key pressed={true} keytype={Keys.RIGHT}></Key>
      <Key pressed={true} keytype={Keys.DOWN}></Key>
    </div>


__CONTROLS__ = null

module.exports =

  mount: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if __CONTROLS__?
      throw new Error("Controls has already been rendered!")
    __CONTROLS__ = React.render <Controls {... props}/>, @_html_element