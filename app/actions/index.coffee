dispatcher = require '../dispatcher'
constants = require './constants'


ACTIONS =

  key_up: (keycode) ->
    dispatcher.dispatch {action: constants.KEYUP, keycode}

  tick: ->
    dispatcher.dispatch {action: constants.TICK}

module.exports = {ACTIONS}

