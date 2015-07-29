Immutable = require 'immutable'
_ = require 'underscore'
Cells = require '../cell/types' # can't require cell directly :(
Random = require './random'

module.exports =
  # A mode is determined by a Map whose keys are Cells,
  # and whose values are a likelihood between 0-100 that
  # a random cell in the grid is that type of Cell.
  #
  # The ranges should be mutually disjoint.

  setting: Immutable.Map([
    [
      Cells.Wall
      Immutable.Range(0, 15)
    ]
    [
      Cells.Item
      Immutable.Range(40, 55)
    ]
  ])

  choice: (cells...) ->
    # This number has to be > 100 to see the expected randomness.
    sample = Random.int(0, 1000)
    _.find cells, (cell) =>
      @setting.get(cell).contains sample
