React = require 'react'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
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

    <ReactCSSTransitionGroup transitionName='controls-key' transitionAppear={true}>
      <div className="key #{@props.keytype.shortname()} #{pressed_class}">
        {@props.keytype.symbol()}
      </div>
    </ReactCSSTransitionGroup>


ArrowKeys = React.createClass

  render: ->
    <div className="arrow-keys">
      <Key pressed={true} keytype={Keys.LEFT}></Key>
      <Key pressed={true} keytype={Keys.UP}></Key>
      <Key pressed={true} keytype={Keys.RIGHT}></Key>
      <Key pressed={true} keytype={Keys.DOWN}></Key>
    </div>


RestartKey = React.createClass

  render: ->
    <Key pressed={false} keytype={Keys.R}></Key>


__RestartKey__ = null
__ArrowKeys__ = null

module.exports = Object.create null,

  _restart_key_node:
    writable: true
    value:
      @_restart_key_node

  _arrow_keys_node:
      writable: true
      value:
        @_arrow_keys_node

  mount_restart_key:
    enumerable: true
    value: (@_restart_key_node) ->
      @

  mount_arrow_keys:
    enumerable: true
    value: (@_arrow_keys_node) ->
      @

  render_arrow_keys:
    enumerable: true
    value: ->
      if !@_arrow_keys_node?
        throw new Error("mount_arrow_keys before rendering!")
      else if __ArrowKeys__?
        throw new Error("ArrowKeys has already been rendered!")
      __ArrowKeys__ = React.render <ArrowKeys/>, @_arrow_keys_node
      @

  render_restart_key:
    enumerable: true
    value: ->
      if !@_restart_key_node?
        throw new Error("mount_restart_key before rendering!")
      else if __RestartKey__?
        throw new Error("RestartKey has already been rendered!")
      __RestartKey__ = React.render <RestartKey/>, @_restart_key_node
      @

  render_keys:
    enumerable: true
    value: ->
      @render_restart_key()
      @render_arrow_keys()