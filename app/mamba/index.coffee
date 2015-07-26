Immutable = require 'immutable'
{position} = require '../util'
settings = require '../settings'

###
  Represents an instance of an expandable, movable snake.

  Backed by an Immutable.OrderedSet, so .meets(xy) and moveare fast.
###
class Mamba

  constructor: (xy_list) ->
    @_frame = Immutable.OrderedSet(xy_list)
    @_front = xy_list[0]
    @_length = 1
    @

  @at_position: (xy) ->
    new @([xy])

  impulse: (xy) ->
    @_motion = xy

  head: ->
    @_frame.first()

  move: ->
    if @_motion?
      new_front = @next_head()
      new_frame = @_frame.take(@_length - 1)
      @_frame = Immutable.OrderedSet.of(new_front, (new_frame.toJS())...)

  length: ->
    @_length

  grow: ->
    @_length++

  meets: (xy) ->
    @_frame.has xy

  next_head: ->
    if @_motion?
      position.add(@_frame.first(), @_motion)
    else
      @_frame.first()

  moving: ->
    @_motion?


module.exports = Mamba