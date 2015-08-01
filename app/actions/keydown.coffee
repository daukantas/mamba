Action = require './action'
_ = require 'underscore'


class KeyDownAction extends Action

  name: 'KEYDOWN'

  validate_payload: (payload) ->
    unless _.isObject(payload) && _.isNumber(payload.keycode)
      throw new Error 'Expected payload to have a number keycode property'

  keycode: ->
    @payload.keycode


module.exports = KeyDownAction