React = require 'react'
Keys = require './types'
Key = require './key'
Deactivates = require './deactivates'
<<<<<<< HEAD
{KeysStore} = require '../../stores'
=======
{PressedKeys} = require '../../stores'
>>>>>>> master


RestartKey = React.createClass

  mixins: [Deactivates]

  getInitialState: ->
    active: false

  componentWillMount: ->
<<<<<<< HEAD
    KeysStore.add_change_listener ({keycode}) =>
=======
    PressedKeys.add_change_listener ({keycode}) =>
>>>>>>> master
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