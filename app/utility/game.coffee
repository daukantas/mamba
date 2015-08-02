Snake = require '../snake'
{GRID} = require '../settings'
Cell = require '../views/cell'
XY = require '../utility/xy'  # can't require utility
{EventEmitter} = require 'events'

Immutable = require 'immutable'

GAME_OVER =

  failure:
    success: false

  success:
    success: true

snake = null
game_over = null
num_items = 0

module.exports = Object.create EventEmitter::,
  ###
    Object that manages the state of the curent game.

    This isn't a Flux Store; it's just a helper class.

    It doesn't handle Actions, it exposes convenience methods for
    manipulating and reading game state, and lives outside the context
    of Actions.
  ###

  reset:
    enumerable: true
    value: ->
      snake = Snake.at_position XY.random(GRID.dimension - 1)
      game_over = null
      num_items = 0

  collision:
    value: (xy) ->
      snake.meets xy

  collide:
    value: (target, xy) ->
      if target is Cell.Wall
        @_fail()
      else if target is Cell.Snake
        if snake.head() is xy
          @_fail()
      else if target is Cell.Item
        @_score()

  set_motion:
    value: (motion) ->
      snake.set_motion(motion)

  move_snake:
    enumerable: true
    value: ->
      snake.move()

  out_of_bounds:
    enumerable: true
    value: ->
      {x, y} = snake.head()
      Math.min(x, y) < 0 ||
      Math.max(x, y) >= GRID.dimension

  add_item:
    enumerable: true
    value: ->
      num_items += 1

  over:
    enumerable: true
    value: ->
      game_over?

  failed:
    enumerable: true
    value: ->
      if game_over?
        not game_over.success
      else
        false

  add_score_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_SCORE_EVENT, listener

  add_game_over_listener:
    enumerable: true
    value: (listener) ->
      @addListener @_GAME_OVER_EVENT, listener

  _SCORE_EVENT:
    value: 'SCORE'

  _GAME_OVER_EVENT:
    value: 'GAME_OVER'

  _score:
    value: ->
      snake.grow()
      num_items -= 1
      if num_items is 0
        game_over = GAME_OVER.success

  _fail:
    value: ->
      snake.set_motion(null)
      game_over = GAME_OVER.failure
