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


class Grub extends CellType

  name: "grub"


class Void extends CellType

  name: "void"


class Wall extends CellType

  name: "wall"


class Snake extends CellType

  name: "snake"


module.exports =
  Grub: new Grub
  Wall: new Wall
  Void: new Void
  Snake: new Snake
