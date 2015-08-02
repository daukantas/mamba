{TICK} = require '../settings'
_ = require 'underscore'

Ticker =
  ###
    Object whose sole responsibility is to call a function on a given interval
    (that's an application-level setting), and allow for stopping said interval.
  ###

  _interval: null

  tick: (callback) ->
    unless _.isFunction callback
      throw new Error "Expected callback function for .tick"
    @_timeout = setTimeout(callback, TICK.interval)

  stop: (on_cleared) ->
    clearTimeout(@_timeout)
    @_timeout = null
    on_cleared?()

  ticking: ->
    @_timeout?


module.exports = Ticker