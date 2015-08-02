Dispatcher = require '../dispatcher'
_ = require 'underscore'
Immutable = require 'immutable'

KeyDownAction = require './keydown'

initialized = false

KeySender = Object.create {},
  ###
    Object that dispatches a pre-configured collection of keycodes.

    jQuery is a dependency, mostly for event normalization, but this can be relaxed.
  ###

  dependencies:
    enumerable: true
    value: Immutable.Map [
      ['jQuery', '$']
    ]

  ###
    Initialize with the required dependencies, and start listening for keys.

    @param {object} dependencies - an object with key-value pairs of dependency
      names to dependency values (no type-checking is done with the values).
  ###
  initialize:
    enumerable: true
    value: (dependencies) ->
      if initialized
        @
      else
        unless _.isObject dependencies
          throw new Error 'Pass an object with required dependencies'
        @dependencies.entrySeq().forEach (entry) =>
          [external_name, internal_name] = entry
          unless _.has dependencies, external_name
            throw new Error "Couldn't find dependency #{external_name}"
          @[internal_name] = dependencies[external_name]
      initialized = true
      @

  ###
    Listen for a collection of keycodes, and emit the KeyDownAction when caught.

    @param {array} keycodes - an array of numerical keycodes to listen for.
    @param {object} options - an options dictionary; currently only prevent_default
      is supported, defaulting to true. when it's true, the keydown event won't
      be propagated after dispatching the KeyDownAction.
  ###
  listen:
    value: (keycodes, options) ->
      @_validate_listen keycodes, options
      options = _.defaults options, prevent_default: true
      keycodes = Immutable.Set keycodes
      @$(document).keydown (ev) ->
        keycode = ev.which
        if keycodes.has keycode
          Dispatcher.dispatch KeyDownAction.of({keycode})
        (options.prevent_default && false) || ev

  _validate_listen:
    value: (keycodes, options) ->
      unless initialized?
        throw new Error("Didn't properly initialize; call .initialize first!")
      unless Array.isArray keycodes
        throw new Error("keycodes array required")
      if options? && !_.isObject options
        throw new Error("options argument should be an object")

module.exports = KeySender