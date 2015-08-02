{EventEmitter} = require 'events'
{NotImplemented} = require '../utility'


module.exports = EmittingStore: Object.create EventEmitter::,

  initialize:
    enumerable: true
    value: ->
      if @_INITIALIZED
        throw new Error "Store already initialized"
      else if !@_handle_action?
        throw new NotImplemented "Define _handle_action method"
      Dispatcher.register (action) =>
        @_handle_action(action)
      @_INITIALIZED = true
      @_post_initialize_hook()

  _INITIALIZED:
    writable: true
    value: false

  _post_initialize_hook:
    enumerable: false
    value: ->
      # no-op; subclasses to override