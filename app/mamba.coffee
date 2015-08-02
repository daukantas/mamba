{CellStore} = require './stores'
{KeySender, KeyDownAction} = require './actions'
Grid = require './views'

$ = window.$

if $?
  ROOT = $('#mamba')[0]

  KeySender
  .initialize(jQuery: $)
  .listen(KeyDownAction.KEYCODES, prevent_default: true)

  CellStore.initialize()

  Grid
  .mount(ROOT)
  .render()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"