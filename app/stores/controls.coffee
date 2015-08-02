{EmittingStore} = require './emitter'

CURRENT_KEY = null

module.exports = Object.create EmittingStore,

  add_change_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_CHANGE_EVENT, listener

  _CHANGE_EVENT:
    value: 'CHANGE'
