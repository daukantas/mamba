Immutable = require 'immutable'
{xy} = require '../util'


class Mamba

  constructor: (xy_list) ->
    @_front = xy_list[0]
    @_frame = Immutable.Set(xy_list)
    @_motion = null
    @

  @at_position: (xy) ->
    new @([xy])

  move: (xy) ->
    @_motion = xy

  length: ->
    @_frame.size

  head: ->
    @_front

  grow: ->
    @_front = xy.value_of(@_front.x + @motion.x, @_front.y + @motion.y)
    @_frame.add(@_front)

  meets: (xy) ->
    @_frame.has xy


module.exports = Mamba