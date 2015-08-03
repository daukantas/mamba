React = require 'react'
Keys = require './types'
Key = require './key'
Deactivates = require './deactivates'
{PressedKeys} = require '../../stores'


RestartKey = React.createClass

  mixins: [Deactivates]

  getInitialState: ->
    active: false

  componentWillMount: ->
    PressedKeys.add_change_listener ({keycode}) =>
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


module.exports = RestartKey