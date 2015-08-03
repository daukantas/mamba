Snake = require '../snake'
{GRID, LEVEL} = require '../settings'
Cell = require '../views/cell'
XY = require '../utility/xy'  # can't require utility

Immutable = require 'immutable'

STATES =

  reset: 'reset'

  failure: 'failure'

  success: 'success'

SNAKE = null
STATE = null
ITEMS = 0
NUM_WINS = 0

module.exports = Object.create null,
  ###
    Object that manages the state of the current game.

    It doesn't handle Actions, it exposes convenience methods for
    manipulating and reading game state, and lives outside the context
    of Actions.

    This isn't a Flux Store; it's just a bookkeeping helper class.
  ###

  reset:
    enumerable: true
    value: ->
      SNAKE = Snake.at_position XY.random(GRID.dimension - 1)
      NUM_WINS = 0
      @reset_round()

  reset_round:
    enumerable: true
    value: ->
      STATE = null
      ITEMS = 0

  track_collision:
    value: (target, xy) ->
      if target is Cell.WALL
        @_fail()
      else if target is Cell.SNAKE
        if SNAKE.head() is xy
          @_fail()
      else if target is Cell.ITEM
        @_score()

  set_motion:
    value: (motion) ->
      SNAKE.set_motion(motion)

  move_snake:
    enumerable: true
    value: ->
      SNAKE.move()

  out_of_bounds:
    enumerable: true
    value: ->
      {x, y} = SNAKE.head()
      Math.min(x, y) < 0 ||
      Math.max(x, y) >= GRID.dimension

  add_item:
    enumerable: true
    value: ->
      ITEMS += 1

  items_left:
    enumerable: true
    value: ->
      ITEMS

  over:
    enumerable: true
    value: ->
      STATE? && STATE isnt STATES.reset

  should_reset_round:
    enumerable: true
    value: ->
      STATE? && STATE is STATES.reset

  failed:
    enumerable: true
    value: ->
      if STATE?
        STATE is STATES.failure
      else
        false

  _score:
    value: ->
      SNAKE.grow()
      ITEMS -= 1
      @_maybe_win()

  _maybe_win:
    value: ->
      if ITEMS is 0
        NUM_WINS += 1
        if NUM_WINS is LEVEL.rounds_to_win
          STATE = STATES.success
        else
          STATE = STATES.reset

  _fail:
    value: ->
      SNAKE.set_motion(null)
      STATE = STATES.failure
