React = require('react');
_ = require('underscore');

Row = require('../row');
settings = require '../settings'


Grid = React.createClass

  getDefaultProps: ->
    reset: false

  componentWillReceiveProps: (next_props) ->
    console.log "Receiving reset #{next_props.reset}"
    @setState stopped: !!next_props.reset

  shouldComponentUpdate: (next_props, next_state) ->
    !next_state.reset

  render: ->
    rows = _.times(settings.GRID.dimension, ->
      <Row length={settings.GRID.dimension} head={@props.head}/>
    , @)

    <div className="grid">{rows}</div>


module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    unless @_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    React.render <Grid {... props}/>, @_html_element