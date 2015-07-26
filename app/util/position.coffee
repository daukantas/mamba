settings = require '../settings'
random = require './random'

class XY

  @value_of: (x, y) ->
    xy = new @
    xy.x = x
    xy.y = y
    xy

  toString: ->
    "{x: #{@x}, y: #{@y}}"


all_xy = {}

module.exports =

  value_of: (row, col) ->
    unless all_xy[row]?[col]?
      all_xy[row] ||= {}
      all_xy[row][col] = XY.value_of(row, col)
    all_xy[row][col]

  random: ->
    row = random.int(0, settings.GRID.dimension);
    col = random.int(0, settings.GRID.dimension);
    @value_of(row, col)

  add: (xy1, xy2) ->
    @value_of(xy1.x + xy2.x, xy1.y + xy2.y)
