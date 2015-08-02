_ = require 'underscore'
{errors} = require '../../utility'


class Key

  constructor: ->
    if @constructor == Key
      throw new Error "Can't instantiate abstract class Key"
    else if !_.isString @constructor.name
      throw new errors.NotImplemented("`name` property not implemented")
    else if !_.isNumber @constructor.keycode
      throw new errors.NotImplemented("`keycode` property not implemented")

  toString: ->
    "Key({name: #{@constructor.name}, keycode: #{@constructor.keycode}})"


class Left extends Key

  @name: "←"
  @keycode: 37


class Up extends Key

  @name: "↑"
  @keycode: 38


class Right extends Key

  @name: "→"
  @keycode: 39


class Down extends Key

  @name: "↓"
  @keycode: 40


class R extends Key

  @name: "r"
  @keycode: 82


module.exports =
  Left: new Left
  Up: new Up
  Right: new Right
  Down: new Down
  R: new R