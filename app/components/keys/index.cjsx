React = require 'react'

ArrowKeys = require './arrows'
RestartKey = require './restart'
{wrap} = require '../wrapper'


module.exports =

  arrows: wrap(<ArrowKeys />)

  restart: wrap(<RestartKey />)