_ = require 'underscore'

class Keyhandler

  constructor: (handler, @$) ->
    @_handler = handler

  @from_handler: (handler, $) ->
    new @(handler, $)

  _extract_keycode: (ev) ->
    ev.which

  handle: ->
    @$(document).on 'keydown', (ev) =>
      @_handler(ev.which)
      false
    @


module.exports =

  from_handler: Keyhandler.from_handler.bind(Keyhandler)