{CellStore} = require './stores'
Grid = require './views'

$ = window.$

if $?
  ROOT = $('#mamba')[0]

  CellStore.initialize()

  Grid
  .mount(ROOT)
  .render()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"