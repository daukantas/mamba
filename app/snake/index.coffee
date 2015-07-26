Immutable = require 'immutable'
{position} = require '../util'
settings = require '../settings'

###
  Represents an instance of an expandable, movable snake.

  Backed by an Immutable.OrderedSet, so .meets(xy) and moveare fast.
###
class Snake

  constructor: (xy_list) ->
    @_this_frame = Immutable.OrderedSet(xy_list)
    @_last_frame = null
    @_front = xy_list[0]
    @_length = 1
    @

  @at_position: (xy) ->
    new @([xy])

  motion: (xy) ->
    if xy?
      if !@_motion?
        @_motion = xy
      else if position.negate(xy) isnt @_motion
        @_motion = xy
    else
      @_motion = null

  head: ->
    @_this_frame.first()

  move: ->
    if @moving()
      new_front = position.add(@_this_frame.first(), @_motion)
      new_frame = @_this_frame.take(@_length - 1)
      @_last_frame = @_this_frame
      @_this_frame = Immutable.OrderedSet.of(new_front, (new_frame.toJS())...)

  length: ->
    @_length

  grow: ->
    @_length++

  meets: (xy) ->
    @_this_frame.has xy

  rewind: ->
    @_this_frame = (@_last_frame? && @_last_frame) || @_this_frame

  moving: ->
    @_motion?


module.exports = Snake