Grid = require '../grid'
_ = require 'underscore'

class Renderer

  constructor: (@html_element) ->
    Grid.html_element(@html_element)
    @_interval = null

  @mount: (html_element) ->
    new @(html_element)

  looping: ->
    @_interval?

  loop: (props_returning_fn, milliseconds) ->
    @stop()
    @_interval = setInterval(
      _.compose(@update, props_returning_fn), milliseconds)
    @

  render: (props = {}) ->
    Grid.render props
    @

  update: (props = {}, callback) ->
    Grid.set_props(props, callback)
    @

  stop: (callback) ->
    clearInterval @_interval
    @_interval = null
    callback?()


module.exports =

  mount: Renderer.mount.bind(Renderer)