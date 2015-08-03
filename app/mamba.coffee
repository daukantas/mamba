{GridEvolver, PressedKeys} = require './stores'
{KeySender, KEYCODES} = require './actions'
{Grid, Keys} = require './views'

$ = window.$

if $?
  GRID = $('#mamba')[0]
  ARROW_KEYS = $('#arrow-keys-container')[0]
  RESTART_KEY = $('#restart-key-container')[0]

  KeySender
  .initialize(jQuery: $)
  .listen(KEYCODES, prevent_default: true)

  PressedKeys.initialize()
  GridEvolver.initialize()

  Grid.mount(GRID).render()

  Keys
  .mount_arrow_keys(ARROW_KEYS)
  .mount_restart_key(RESTART_KEY)
  .render_keys()
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"