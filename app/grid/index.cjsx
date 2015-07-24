React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba' # can't require this!
Row = require '../row'
settings = require '../settings'


Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool
    mamba: React.PropTypes.any.isRequired
    mode: React.PropTypes.objectOf(React.PropTypes.number)

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

  set_props: (props) ->
    if !GRID?
      throw new Error("Grid hasn't been rendered!")
    GRID.setProps(props)