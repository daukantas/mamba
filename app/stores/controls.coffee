{EmittingStore} = require './emitter'
{MotionKeyAction} = require '../actions'


module.exports = Object.create EmittingStore,

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_CHANGE_EVENT, listener

  _CHANGE_EVENT:
    value: 'CHANGE'

  _post_initialize_hook:
    value: ->
      @_current_keycode = null

  current_keycode:
    enumerable: true
    get: ->
      @_current_keycode
    set: (keycode) ->
      if keycode isnt @_current_keycode
        @_current_keycode = keycode
        @emit @_CHANGE_EVENT, {keycode}

  _handle_action:
    value: (action) ->
      if action.is_a MotionKeyAction
        @current_keycode = action.keycode()