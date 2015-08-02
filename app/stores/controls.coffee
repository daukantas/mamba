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
      @_current_motion = null

  current_motion:
    enumerable: true
    get: ->
      @_current_motion
    set: (motion) ->
      if motion isnt @_current_motion
        @_current_motion = motion
        console.log "Detected change #{motion}"
        @emit @_CHANGE_EVENT, {motion}

  _handle_action:
    value: (action) ->
      if action.is_a MotionKeyAction
        @current_motion = action.motion()