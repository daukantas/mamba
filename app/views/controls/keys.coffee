_ = require 'underscore'
{errors} = require '../../utility'


class Key

  constructor: ->
    if @constructor == Key
      throw new Error "Can't instantiate abstract class Key"
    else if !_.isString @constructor.symbol
      throw new errors.NotImplemented("`symbol` property not implemented")
    else if !_.isString @constructor.shortname
      throw new errors.NotImplemented("`symbol` property not implemented")
    else if !_.isNumber @constructor.keycode
      throw new errors.NotImplemented("`keycode` property not implemented")

  toString: ->
    "Key({symbol: #{@constructor.symbol}, keycode: #{@constructor.keycode}})"

  symbol: ->
    @constructor.symbol

  keycode: ->
    @constructor.keycode

  shortname: ->
    @constructor.shortname


class Left extends Key

  @symbol: "←"
  @keycode: 37
  @shortname: "left"


class Up extends Key

  @symbol: "↑"
  @keycode: 38
  @shortname: "up"


class Right extends Key

  @symbol: "→"
  @keycode: 39
  @shortname: "right"


class Down extends Key

  @symbol: "↓"
  @keycode: 40
  @shortname: "down"


class R extends Key

  @symbol: "R"
  @keycode: 82
  @shortname: "r"


module.exports =
  LEFT: new Left
  UP: new Up
  RIGHT: new Right
  DOWN: new Down
  R: new R