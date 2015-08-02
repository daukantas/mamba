Action = require './action'
_ = require 'underscore'
Immutable = require 'immutable'
{XY} = require '../utility'


class KeyDownAction extends Action

  @KEYCODES: [
    37 # ←
    38 # ↑
    39 # →
    40 # ↓
    82 # r
  ]

  @MOTION_KEYS: Immutable.Map [
    [37, XY.left()]
    [38, XY.up()]
    [39, XY.right()]
    [40, XY.down()]
  ]

  @METHOD_KEYS: Immutable.Map [
    [82, 'restart']
  ]

  @validate_payload: (payload) ->
    unless _.isObject(payload) && _.isNumber(payload.keycode)
      throw new Error 'Expected payload to have a number keycode property'

  motion: ->
    @constructor.MOTION_KEYS.get(@payload.keycode) || null

  method: ->
    @constructor.METHOD_KEYS.get(@payload.keycode) || null


module.exports = KeyDownAction