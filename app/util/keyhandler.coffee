_ = require 'underscore'

class Keyhandler

  constructor: (handler, @$) ->
    @_handler = handler

  @from_handler: (handler, $) ->
    new @(handler, $)

  _extract_keycode: (ev) ->
    ev.which

  handle: (keycodes, options = {prevent_default: true}) ->
    @$(document).on 'keydown', (ev) =>
      keycode = ev.which
      if keycodes.has(keycode)
        @_handler(keycode)
        not options.prevent_default
      else
        ev
    @


module.exports =

  from_handler: Keyhandler.from_handler.bind(Keyhandler)