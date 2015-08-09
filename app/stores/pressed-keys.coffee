{EmittingStore} = require './emitter'
{KeyDownAction} = require '../actions'


module.exports = Object.create EmittingStore,

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_CHANGE_EVENT, listener

  _CHANGE_EVENT:
    value: 'CHANGE'

  _handle_action:
    value: (action) ->
      if action.is_a KeyDownAction
        @emit @_CHANGE_EVENT, {keycode: action.keycode()}