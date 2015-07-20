$ = window.$

unless $?
  throw new Error 'jQuery must be loaded.'


_ = require 'underscore'

Mamba = require './mamba'
Grid = require './grid'
{GRID} = require './settings'


impulse_map =
    37:
      x: -1
      y: 0
    38:
      x: 0
      y: 1
    39:
      x: 1
      y: 0
    40:
      x: 0
      y: -1


# Create a new Mamba and Grid
mamba = new Mamba(GRID.start_position())



# TODO: clean this up when restarting the game
$(document).keyup (event) ->
  impulse = impulse_map[event.keyCode]
  if impulse?
    mamba.impulse(impulse)
  else
    event.preventDefault()