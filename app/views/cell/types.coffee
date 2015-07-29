_ = require 'underscore'


class NotImplemented extends Error


class CellType

  constructor: ->
    if @constructor == CellType
      throw new Error "Can't instantiate abstract class CellType"
    else if !@name
      throw new NotImplemented("`name` property not implemented")

  toString: ->
    @name


class Item extends CellType

  name: "item"


class Void extends CellType

  name: "void"


class Wall extends CellType

  name: "wall"


class Snake extends CellType

  name: "snake"


class Collision extends CellType

  name: "collision"


module.exports =
  Item: new Item
  Wall: new Wall
  Void: new Void
  Snake: new Snake
  Collision: new Collision
