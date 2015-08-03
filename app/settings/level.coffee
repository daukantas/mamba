Immutable = require 'immutable'
_ = require 'underscore'
Cells = require '../views/cell/types' # can't require cell directly :(
Random = require '../utility/random'  # can't require utility directly :(
GRID = require './grid'


CELL_QUANTITIES= Immutable.Map [
  [
    Cells.WALL
    15
  ]
  [
    Cells.ITEM
    10
  ]
]

# Helper map for random_reset algorithm
cellcodes = Immutable.Map [
  [Cells.VOID, 0]
  [Cells.WALL, 1]
  [Cells.ITEM, 2]
]


module.exports = Object.create null,

  rounds_to_win:
    enumerable: true
    value: 3

  max_score:
    enumerable: true
    value: ->
      (CELL_QUANTITIES.get Cells.ITEM) * @rounds_to_win

  random_reset:
    enumerable: true
    value: (immutable_cellmap) ->
      voided_cells = immutable_cellmap.withMutations (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if cell isnt Cells.SNAKE
            mutable_cells.set xy, Cells.VOID

      to_repopulate = Immutable.OrderedMap(voided_cells
        .entrySeq()
        .filter((entry) ->
          [xy, cell] = entry
          cell isnt Cells.SNAKE
        )
        .map((entry) -> [entry[0], null]))

      num_walls = CELL_QUANTITIES.get Cells.WALL
      num_items = CELL_QUANTITIES.get Cells.ITEM

      # The sequel reasonably assumes this quantity is > 0; if we
      # write down them math, it probably more than works out.
      num_voids = to_repopulate.size - num_walls - num_items

      # Max size of this is (GRID.dimension - 1) squared; ~< 900.
      grid_profile = (
        cellcodes.get(Cells.WALL) for _ in [0...num_walls]
      ).concat (
        cellcodes.get(Cells.ITEM) for _ in [0...num_items]
      ).concat (
        cellcodes.get(Cells.VOID) for _ in [0...num_voids]
      )

      Random.shuffle(grid_profile)

      to_repopulate = to_repopulate.withMutations (mutable_cells) ->
        mutable_cells.entrySeq().forEach (entry, index) ->
          [xy, __] = entry
          mutable_cells.set xy, cellcodes.keyOf(grid_profile[index])

      new_cellmap = immutable_cellmap.withMutations (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if to_repopulate.has xy
            mutable_cells.set(xy, to_repopulate.get(xy))

      # set up for GC
      grid_profile = null
      to_repopulate = null

      new_cellmap