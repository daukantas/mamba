settings = require '../settings'


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
  # implementation:  https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    row = Math.floor(Math.random() * (settings.GRID.dimension + 1));
    col = Math.floor(Math.random() * (settings.GRID.dimension + 1));
    @value_of(row, col)

  add: (xy1, xy2) ->
    @value_of(xy1.x + xy2.x, xy1.y + xy2.y)
