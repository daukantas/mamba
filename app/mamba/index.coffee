Immutable = require 'immutable'


class Mamba

  @at_position: (xy) ->
    new Mamba([xy])

  constructor: (xy_pairs) ->
    @_front = xy_pairs[0]
    @_frame = Immutable.Set.of(xy_pairs...)
    @_motion = null

  move: ({x, y}) ->
    @_motion = {x, y}

  length: ->
    @_coors.size()

  head: ->
    @_front

  grow: ->
    @_front = {x: @_front.x + @motion.x, y: @_front.y + @motion.y}
    @_frame.add(@_front)

  meets: ({x, y}) ->
    @_frame.has {x, y}

module.exports = Mamba
