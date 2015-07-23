_ = require 'underscore'

class Keyhandler

  constructor: (handler, @$) ->
    @_handler = _.compose(handler, @_extract_keycode).bind(@)

  @from_handler: (handler, $) ->
    new @(handler, $)

  reset: ->
    @$(document).off('keyup', @_handler)
    @handle()
    @

  _extract_keycode: (ev) ->
    ev.which

  handle: ->
    @$(document).on('keyup', @_handler)
    @


module.exports =

  from_handler: Keyhandler.from_handler.bind(Keyhandler)