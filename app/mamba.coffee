Snake = require './snake'
Cell = require './cell'
settings = require './settings'
{keyhandler, renderer, position, game_over} = require './util'

_ = require 'underscore'
Immutable = require 'immutable'
$ = window.$


if $?
  ROOT = $('#mamba')[0]
  window.mamba = new Mamba ROOT
else
  throw new Error "Couldn't find window.$, are you sure jQuery is loaded?"