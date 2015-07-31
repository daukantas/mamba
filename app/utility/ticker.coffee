dispatcher = require '../dispatcher'
{ACTIONS} = require '../actions'
{TICK} = require '../settings'

ticker =

  _interval: null
  _ticking: false

  tick: (ticker_fn) ->
    @_interval = setInterval(ticker_fn, TICK.interval)

  stop: (on_stop) ->
    clearInterval(@_interval)
    @_interval = null
    on_stop?()

  ticking: ->
    @_ticking