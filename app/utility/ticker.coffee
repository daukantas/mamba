dispatcher = require '../dispatcher'
{ACTIONS} = require '../actions'
{TICK} = require '../settings'

ticker =

  _interval: null
  _ticking: false

  tick: ->
    @_interval = setInterval(ACTIONS.tick, TICK.interval)

  stop: (callback) ->
    clearInterval(@_interval)
    @_interval = null
    callback?()

  ticking: ->
    @_ticking