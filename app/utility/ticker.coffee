{TICK} = require '../settings'
_ = require 'underscore'

Ticker =
  ###
    Object whose sole responsibility is to call a function on a given interval
    (that's an application-level setting), and allow for stopping said interval.
  ###

  _interval: null

  tick: (on_tick) ->
    unless _.isFunction on_tick
      throw new Error "Expected callback function for .tick"
    @_interval = setInterval(on_tick, TICK.interval)

  stop: (on_stopped) ->
    clearInterval(@_interval)
    @_interval = null
    on_stopped?()

  ticking: ->
    @_interval?


module.exports = Ticker