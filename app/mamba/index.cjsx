class Mamba

  constructor: ({x, y}) ->
    @_head = {x, y}
    @_impulse = null
    @_length = 1

  impulse: ({x, y}) ->
    @_impulse = {x, y}
    console.info "Moving {x: #{@_impulse.x}, y: #{@_impulse.y}}!"

  length: ->
    @_length

module.exports = Mamba