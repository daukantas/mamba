{CellStore, ControlStore} = require './stores'
{KeySender, KEYCODES} = require './actions'
{Grid, Controls} = require './views'

$ = window.$

if $?
  GRID = $('#mamba')[0]
  CONTROLS = $('#keys')[0]

  KeySender
  .initialize(jQuery: $)
  .listen(KEYCODES, prevent_default: true)

  ControlStore.initialize()
  CellStore.initialize()

  Grid.mount(GRID).render()
  Controls.mount(CONTROLS).render()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"