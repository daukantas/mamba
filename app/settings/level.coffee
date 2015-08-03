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
    5
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
    value: 5

  max_score:
    enumerable: true
    value: ->
      (CELL_QUANTITIES.get Cells.ITEM) * @rounds_to_win

  random_reset:
    enumerable: true
    value: (immutable_cellmap) ->
      valid_xys = Immutable.OrderedSet(immutable_cellmap
        .entrySeq()
        .filter((entry) ->
          [xy, cell] = entry
          cell isnt Cells.SNAKE
        )
        .map((entry) -> entry[0]))

      num_walls = CELL_QUANTITIES.get Cells.WALL
      num_items = CELL_QUANTITIES.get Cells.ITEM
      num_voids = valid_xys.size - num_walls - num_items

      # Max size of this is (GRID.dimension - 1) squared; ~< 900.
      grid_profile = (
        cellcodes.get(Cells.WALL) for _ in [0...num_walls]
      ).concat (
        cellcodes.get(Cells.ITEM) for _ in [0...num_items]
      ).concat (
        cellcodes.get(Cells.VOID) for _ in [0...num_voids]
      )

      Random.shuffle(grid_profile)

      new_cellmap = immutable_cellmap.withMutations (mutable_cells) ->
        mutable_cells.forEach (cell, xy) ->
          if valid_xys.has xy
            profile_index = ((GRID.dimension - 1) * xy.x) + xy.y
            mutable_cells.set xy, cellcodes.keyOf grid_profile[profile_index]
          else
            mutable_cells.set xy, Cells.SNAKE

      # set up for GC
      grid_profile = null
      valid_xys = null

      new_cellmap