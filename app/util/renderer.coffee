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

  loop: (props_returning_fn) ->
    @stop()
    @_interval = setInterval(
      _.compose(@update, props_returning_fn), settings.RENDER.interval)
    @

  reset: (props = {}) ->
    Grid.set_props(_.extend props, reset: true)
    @stop()
    @

  render: (props = {}) ->
    Grid.render _.defaults(props, {reset: true})
    @

  update: (props = {}) ->
    Grid.set_props _.defaults(props, {reset: false})
    @

  stop: ->
    clearInterval @_interval
    @_interval = null


module.exports =

  mount: Renderer.mount.bind(Renderer)