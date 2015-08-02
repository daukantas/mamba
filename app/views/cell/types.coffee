_ = require 'underscore'
{errors} = require '../../utility'


class CellType

  constructor: ->
    if @constructor == CellType
      throw new Error "Can't instantiate abstract class CellType"
    else if !_.isString @constructor.name
      throw new errors.NotImplemented("`name` property not implemented")

  toString: ->
    @constructor.name


class Item extends CellType

  @name: "item"


class Void extends CellType

  @name: "void"


class Wall extends CellType

  @name: "wall"


class Snake extends CellType

  @name: "snake"


class Collision extends CellType

  @name: "collision"


module.exports =
  ITEM: new Item
  WALL: new Wall
  VOID: new Void
  SNAKE: new Snake
  COLLISION: new Collision
