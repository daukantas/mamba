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
    @_clear()
    @_interval = setInterval(
      _.compose(@_render, props_fn), settings.render_interval)
    @

  reset: (props = {}) ->
    @_render(_.extend props, reset: true)
    @_clear()
    @

  _render: (props = {}) =>
    Grid.render _.defaults(props, reset: false)

  _clear: ->
    clearInterval @_interval
    @_interval = null


module.exports =

  mount: Renderer.mount.bind(Renderer)