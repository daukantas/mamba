_ = require 'underscore'
{errors} = require '../../utility'


class Key

  constructor: ->
    if @constructor == Key
      throw new Error "Can't instantiate abstract class Key"
    else if !_.isString @constructor.symbol
      throw new errors.NotImplemented("`symbol` property not implemented")
    else if !_.isNumber @constructor.keycode
      throw new errors.NotImplemented("`keycode` property not implemented")

  toString: ->
    "Key({symbol: #{@constructor.symbol}, keycode: #{@constructor.keycode}})"

  symbol: ->
    @constructor.symbol

  keycode: ->
    @constructor.keycode


class Left extends Key

  @symbol: "←"
  @keycode: 37


class Up extends Key

  @symbol: "↑"
  @keycode: 38


class Right extends Key

  @symbol: "→"
  @keycode: 39


class Down extends Key

  @symbol: "↓"
  @keycode: 40


class R extends Key

  @symbol: "R"
  @keycode: 82


module.exports =
  Left: new Left
  Up: new Up
  Right: new Right
  Down: new Down
  R: new R