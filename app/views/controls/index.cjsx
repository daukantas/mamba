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
    <div className="controls-key">
      {@props.keytype.symbol()}
    </div>


Controls = React.createClass

  render: ->
    <div className="key-controls">
      <Key pressed={true} keytype={Keys.R}></Key>
      <Key pressed={true} keytype={Keys.Left}></Key>
      <Key pressed={true} keytype={Keys.Up}></Key>
      <Key pressed={true} keytype={Keys.Right}></Key>
      <Key pressed={true} keytype={Keys.Down}></Key>
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