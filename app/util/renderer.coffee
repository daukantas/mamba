Grid = require '../grid'
settings = require '../settings'
_ = require 'underscore'

class Renderer

  constructor: (@html_element) ->
    Grid.html_element(@html_element)
    @_interval = null

  @mount: (html_element) ->
    new @(html_element)

  looping: ->
    @_interval?

  loop: (props_fn) ->
    @_stop_render()
    @_interval = setInterval(
      _.compose(@render, props_fn), settings.RENDER.interval)
    @

  reset: (props = {}) ->
    @render(_.extend props, reset: true)
    @_stop_render()
    @

  render: (props = {}) =>
    Grid.render _.defaults(props, {reset: false})
    @

  _stop_render: ->
    clearInterval @_interval
    @_interval = null


module.exports =

  mount: Renderer.mount.bind(Renderer)