Immutable = require 'immutable'
{position} = require '../util'
settings = require '../settings'


class Mamba

  constructor: (xy_list) ->
    @_frame = Immutable.Set(xy_list)
    @_motion = null
    @

  @at_position: (xy) ->
    new @([xy])

  impulse: (xy) ->
    @_motion = xy

  move: ->
    if @_motion?
      @_frame = @_frame.map (xy) =>
        position.add(xy, @_motion)

  length: ->
    @_frame.size

  grow: ->
    @_front = position.add(@_front, @_motion)
    @_frame.add(@_front)

  meets: (xy) ->
    @_frame.has xy

  moving: ->
    @_motion?


module.exports = Mamba