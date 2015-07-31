dispatcher = require '../dispatcher'
{ACTIONS} = require '../actions'
{TICK} = require '../settings'
_ = require 'underscore'

Ticker =

  _interval: null

  tick: (on_tick) ->
    throw new Error("Expected callback function") unless _.isFunction on_tick

    @_interval = setInterval(on_tick, TICK.interval)

  stop: (on_stop) ->
    clearInterval(@_interval)
    @_interval = null
    on_stop?()

  ticking: ->
    @_interval?


module.exports = Ticker