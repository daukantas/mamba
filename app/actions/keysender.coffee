Dispatcher = require '../dispatcher'
_ = require 'underscore'
Immutable = require 'immutable'

KeyDownAction = require './keydown'

initialized = false

KeySender =
  ###
    Object that dispatches a pre-configured collection of keycodes.

    jQuery is a dependency, mostly for event normalization, but this can be relaxed.
  ###

  dependencies: Immutable.Set.of('$')

  ###
    Initialize with the required dependencies.

    @param {object} dependencies - an object with key-value pairs of dependency
      names to dependency values (no type-checking is done with the values).
  ###
  initialize: (dependencies) ->
    if initialized
      @
    else
      unless _.isObject dependencies
        throw new Error 'Pass an object with required dependencies'
      for dependency in @dependencies
        unless _.has dependencies, dependency
          throw new Error "Couldn't find dependency #{dependency}"
      _.extend(@, _.pick(dependencies, @dependencies.toJS()))
    initialized = true

  ###
    Listen for a collection of keycodes, and emit the KeyDownAction when caught.

    @param {array} keycodes - an array of numerical keycodes to listen for.
    @param {object} options - an options dictionary; currently only prevent_default
      is supported, defaulting to true. when it's true, the keydown event won't
      be propagated after dispatching the KeyDownAction.
  ###
  listen: (keycodes, options) ->
    @_validate_listen keycodes, options
    options = _.defaults options, prevent_default: true
    keycodes = Immutable.Set keycodes
    @$(document).keydown (ev) ->
      keycode = ev.which
      if keycodes.has keycode
        Dispatcher.dispatch KeyDownAction.of(keycode)
      (options.prevent_default && false) || ev

  _validate_listen: (keycodes, options) ->
    unless initialized?
      throw new Error("Didn't properly initialize; call .initialize first!")
    unless Array.isArray keycodes
      throw new Error("keycodes array required")
    if options? && !_.isObject options
      throw new Error("options argument should be an object")

module.exports = KeySender