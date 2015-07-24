React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba' # can't require this!
Row = require '../row'
settings = require '../settings'


Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool.isRequired
    mamba: React.PropTypes.any.isRequired
    mode: React.PropTypes.objectOf(React.PropTypes.number).isRequired
    collision: React.PropTypes.func.isRequired

  render: ->
    range = settings.GRID.range()
    <div className="grid">
      {<Row {... @props} row={row} key={"row-#{row}"} /> for row in range}
    </div>


GRID = null

module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if GRID?
      throw new Error("Grid's already been rendered!")
    GRID = React.render <Grid {... props}/>, @_html_element

  # This is supposed to be an anti-pattern, but I
  # don't find it difficult to reason about.
  #
  # https://facebook.github.io/react/docs/component-api.html
  set_props: (props, callback) ->
    if !GRID?
      throw new Error("Grid hasn't been rendered!")
    GRID.setProps(props, callback)