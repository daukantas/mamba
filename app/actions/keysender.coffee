Dispatcher = require '../dispatcher'
_ = require 'underscore'
Immutable = require 'immutable'

KeyDownAction = require './keydown'


Keysender =

  $: (@$) ->

  listen: (keycodes, options) ->
    @_validate_listen_args keycodes, options
    options = _.defaults options, prevent_default: true
    keycodes = Immutable.Set keycodes
    @$(document).keydown (ev) =>
      normalized_keycode = ev.which
      if keycodes.has normalized_keycode
        @_send_keydown normalized_keycode
      (options.prevent_default && false) || ev

  _validate_listen_args: (keycodes, options) ->
    unless @$?
      throw new Error("jQuery $ is a required dependency")
    unless Array.isArray keycodes
      throw new Error("keycodes array required")
    if options? && !_.isObject options
      throw new Error("options argument should be an object")

  _send_keydown: (keycode) ->
    Dispatcher.dispatch KeyDownAction.of(keycode)

module.exports = Keysender