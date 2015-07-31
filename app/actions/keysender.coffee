dispatcher = require '../dispatcher'
constants = require './constants'
_ = require 'underscore'
Immutable = require 'immutable'


keysender =

  $: (@$) ->

  listen: (keycodes, options) ->
    @_validate_listen(keycodes, options)
    options = _.defaults options, {prevent_default: true}
    keycodes = Immutable.Set(keycodes)
    @$(document).keydown (ev) =>
      normalized_keycode = ev.which
      if keycodes.has normalized_keycode
        @_send_keydown normalized_keycode
      (options.prevent_default && false) || ev

  _validate_listen: (keycodes, options) ->
    unless @$?
      throw new Error("jQuery $ is a required dependency")
    unless Array.isArray(keycodes)
      throw new Error("keycodes array required")
    if options? && !_.isObject options
      throw new Error("options argument should be an object")

  _send_keydown: (keycode) ->
    dispatcher.dispatch {action: constants.KEYUP, keycode}

module.exports = {keyhandler}

