class Mamba

  @at_position: ({x, y}) ->
    mamba = new Mamba()
    mamba._head = {x, y}
    mamba

  constructor: ->
    @_head = null
    @_impulse = null
    @_length = 1

  impulse: ({x, y}) ->
    @_impulse = {x, y}
    console.info "Moving {x: #{@_impulse.x}, y: #{@_impulse.y}}!"

  length: ->
    @_length

  head: ->
    @_head

  grow: ->
    @_length++

module.exports = {at_position: Mamba.at_position}