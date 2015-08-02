Snake = require '../snake'
{GRID} = require '../settings'
Cell = require '../views/cell'
XY = require '../utility/xy'  # can't require utility

Immutable = require 'immutable'

GAME_OVER_STATES =

  failure:
    success: false

  success:
    success: true

SNAKE = null
ITEMS = 0
GAME_OVER = null

module.exports = Object.create null,
  ###
    Object that manages the state of the current game.

    It doesn't handle Actions, it exposes convenience methods for
    manipulating and reading game state, and lives outside the context
    of Actions.

    This isn't a Flux Store; it's just a helper class.
  ###

  reset:
    enumerable: true
    value: ->
      SNAKE = Snake.at_position XY.random(GRID.dimension - 1)
      GAME_OVER = null
      ITEMS = 0

  collision:
    value: (xy) ->
      SNAKE.meets xy

  collide:
    value: (target, xy) ->
      if target is Cell.Wall
        @_fail()
      else if target is Cell.Snake
        if SNAKE.head() is xy
          @_fail()
      else if target is Cell.Item
        @_score()

  set_motion:
    value: (motion) ->
      SNAKE.set_motion(motion)

  move_SNAKE:
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

  over:
    enumerable: true
    value: ->
      GAME_OVER?

  failed:
    enumerable: true
    value: ->
      if GAME_OVER?
        not GAME_OVER.success
      else
        false

  _score:
    value: ->
      SNAKE.grow()
      ITEMS -= 1
      @emit @_SCORE_EVENT
      @_maybe_win()

  _maybe_win:
    value: ->
      if ITEMS is 0
        GAME_OVER = GAME_OVER_STATES.success
        @emit @_GAME_OVER_EVENT, {GAME_OVER}

  _fail:
    value: ->
      SNAKE.set_motion(null)
      game_over = GAME_OVER_STATES.failure
      @emit @_GAME_OVER_EVENT, {game_over}
