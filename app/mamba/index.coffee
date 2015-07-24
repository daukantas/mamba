Immutable = require 'immutable'
{xy} = require '../util'
settings = require '../settings'


class Mamba

  constructor: (xy_list) ->
    @_frame = Immutable.Set(xy_list)
    @_motion = null
    @

  @at_position: (xy_obj) ->
    new @([xy_obj])

  impulse: (xy_obj) ->
    @_motion = xy_obj

  move: ->
    if @_motion?
      @_frame = @_frame.map (xy_obj) =>
        xy.add(xy_obj, @_motion)

  length: ->
    @_frame.size

  grow: ->
    @_front = xy.add(@_front, @_motion)
    @_frame.add(@_front)

  meets: (xy_obj) ->
    @_frame.has xy_obj

  moving: ->
    @_motion?


module.exports = Mamba