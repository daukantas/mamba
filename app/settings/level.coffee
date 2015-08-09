Immutable = require 'immutable'
_ = require 'underscore'
Cells = require '../components/cell/types' # can't require cell directly :(


CELL_QUANTITIES= Immutable.Map [
  [
    Cells.WALL
    15
  ]
  [
    Cells.ITEM
    5
  ]
]

module.exports = Object.create null,

  rounds_to_win:
    enumerable: true
    value: 4

  max_score:
    enumerable: true
    value: ->
      (CELL_QUANTITIES.get Cells.ITEM) * @rounds_to_win

  get_cell_quantity:
    enumerable: true
    value: (cell) ->
      CELL_QUANTITIES.get cell

