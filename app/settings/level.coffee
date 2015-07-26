Immutable = require 'immutable'
Cells = require '../cell/types' # can't require cell directly :(

module.exports =
  # A mode is determined by a Map whose keys are Cells,
  # and whose values are a likelihood between 0-100 that
  # a random cell in the grid is that type of Cell.
  #
  # The ranges should be mutually disjoint.

  easy: Immutable.Map([
    [
      Cells.Wall
      Immutable.Range(0, 5)
    ]
    [
      Cells.Item
      Immutable.Range(10, 15)
    ]
  ])

  get: ->
    # no-op for now
    @easy