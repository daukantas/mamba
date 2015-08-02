React = require 'react'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
{ControlStore} = require '../../stores'
Keys = require './keys'
{errors} = require '../../utility'

Immutable = require 'immutable'
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


Deactivates =

  DEACTIVATE_TIMEOUT: 250

  componentWillMount: ->
    unless @_deactivate?
      throw new errors.NotImplemented "Mixing classes should implement _deactivate"
    unless @_should_deactivate?
          throw new errors.NotImplemented "Mixing classes should implement _should_deactivate"

  componentDidUpdate: (__, prev_state)->
    if @_should_deactivate()
      # need this check to guard against infinite recursion!
      console.log "Deactivate"
      setTimeout =>
        @_deactivate()
      , @DEACTIVATE_TIMEOUT


ArrowKeys = React.createClass

  mixins: [Deactivates]

  componentWillMount: ->
    @setState active_by_key: Immutable.Map [
     [Keys.LEFT, false]
     [Keys.UP, false]
     [Keys.RIGHT, false]
     [Keys.DOWN, false]
    ]

    ControlStore.add_change_listener ({keycode}) =>
      @_on_change({keycode})

  shouldComponentUpdate: (__, next_state) ->
    next_state.active_by_key isnt @state.active_by_key

  _on_change: ({keycode}) ->
    active_by_key = @state.active_by_key.withMutations (mutable_keys) ->
      mutable_keys.forEach (active, key) ->
        mutable_keys.set(key, key.keycode() is keycode)
    @setState {active_by_key}

  _should_deactivate: ->
    @state.active_by_key.includes true

  _deactivate: ->
    @setState active_by_key: @state.active_by_key.withMutations (mutable_keys) ->
      mutable_keys.forEach (__, key) ->
        mutable_keys.set(key, false)

  render: ->
    <div className="arrow-keys">
      {@state.active_by_key.entrySeq().toJS().map (entry, index) ->
         [key, active] = entry
         <Key pressed={active} keytype={key} key={index}></Key>
       }
    </div>


RestartKey = React.createClass

  mixins: [Deactivates]

  getInitialState: ->
    active: false

  componentWillMount: ->
    ControlStore.add_change_listener ({keycode}) =>
      @_on_change({keycode})

  _should_deactivate: ->
    @state.active is true

  _deactivate: ->
    @setState active: false

  _on_change: ({keycode}) ->
    if Keys.R.keycode() is keycode
      @setState active: true

  render: ->
    <Key pressed={@state.active} keytype={Keys.R}></Key>


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