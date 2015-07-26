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

  move: ->
    if @_motion?
      new_front = position.add(@_frame.first(), @_motion)
      new_frame = @_frame.take(@_length - 1)
      @_frame = Immutable.OrderedSet.of(new_front, (new_frame.toJS())...)

  length: ->
    @_length

  grow: ->
    @_length++

  meets: (xy) ->
    @_frame.has xy

  moving: ->
    @_motion?


module.exports = Mamba