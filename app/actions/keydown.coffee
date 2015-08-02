Action = require './action'
_ = require 'underscore'
Immutable = require 'immutable'
{XY} = require '../utility'


class KeyDownAction extends Action

  @KEYCODES: Immutable.Set [
    37 # ←
    38 # ↑
    39 # →
    40 # ↓
    82 # r
  ]

  @validate_payload: (payload) ->
    unless _.isObject(payload) && _.isNumber(payload.keycode)
      throw new Error 'Expected payload to have a number keycode property'

  @post_of_hook: (payload) ->
    {keycode} = payload

    if MotionKeyAction.KEYCODES.has keycode
      new MotionKeyAction(payload)
    else if MethodKeyAction.KEYCODES.has keycode
      new MethodKeyAction(payload)
    else
      throw new Error "Unsupported keycode: #{keycode}; try #{@KEYCODES}"


class MotionKeyAction extends KeyDownAction

  @KEYCODES: Immutable.Map [
    [37, XY.left()]
    [38, XY.up()]
    [39, XY.right()]
    [40, XY.down()]
  ]

  motion: ->
    @constructor.KEYCODES.get(@payload.keycode) || null


class MethodKeyAction extends KeyDownAction

  @KEYCODES: Immutable.Map [
    [82, 'restart']
  ]

  method: ->
    @constructor.KEYCODES.get(@payload.keycode) || null


module.exports = {
  KEYCODES: KeyDownAction.KEYCODES,

  KeyDownAction: KeyDownAction.of.bind(KeyDownAction),

  MotionKeyAction, MethodKeyAction
}