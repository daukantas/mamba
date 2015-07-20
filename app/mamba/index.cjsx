class Mamba

  constructor: ({x, y}) ->
    @_head = {x, y}
    @_impulse = null
    @_length = 1

  impulse: ({x, y}) ->
    @_impulse = {x, y}

  length: ->
    @_length

module.exports = Mamba