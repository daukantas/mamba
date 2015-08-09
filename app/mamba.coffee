{GridEvolver, PressedKeys} = require './stores'
{KeySender, KEYCODES} = require './actions'
{Grid, Keys, Score} = require './components'

$ = window.$

if $?
  GRID = $('#mamba')[0]
  SCOREBOARD = $('#scoreboard')[0]
  ARROW_KEYS = $('#arrow-keys-container')[0]
  RESTART_KEY = $('#restart-key-container')[0]

  KeySender
  .initialize(jQuery: $)
  .listen(KEYCODES, prevent_default: true)

  PressedKeys.initialize()
  GridEvolver.initialize()

  Grid.mount(GRID).render()
  Score.mount(SCOREBOARD).render()

  Keys.arrows.mount(ARROW_KEYS).render()
  Keys.restart.mount(RESTART_KEY).render()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"