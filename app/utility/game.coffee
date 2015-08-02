Snake = require '../snake'
{GRID} = require '../settings'
Cell = require '../views/cell'
XY = require '../utility/xy'  # can't require utility

Immutable = require 'immutable'

GAME_OVER =

  failure:
    success: false

  success:
    success: true


module.exports =

  reset: ->
    @_snake = Snake.at_position XY.random(GRID.dimension - 1)
    @_game_over = null
    @_num_items = 0

  collision: (xy) ->
    @_snake.meets xy

  collide: (target, xy) ->
    if target is Cell.Wall
      @_fail()
    else if target is Cell.Snake && @_snake.head() is xy
      @_fail()
    else if target is Cell.Item
      @_score()

  set_motion: (motion) ->
    @_snake.set_motion(motion)

  move_snake: ->
    @_snake.move()

  out_of_bounds: ->
    {x, y} = @_snake.head()
    Math.min(x, y) < 0 ||
    Math.max(x, y) >= GRID.dimension

  add_item: ->
    @_num_items += 1

  over: ->
    @_game_over?

  failed: ->
    if @_game_over?
      not @_game_over.success
    else
      false

  _score: ->
    @_snake.grow()
    @_num_items -= 1
    if @_num_items is 0
      @_game_over = GAME_OVER.success

  _fail: ->
    @_snake.set_motion(null)
    @_game_over = GAME_OVER.failure
