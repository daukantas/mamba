React = require 'react'
_ = require 'underscore'

Mamba = require '../mamba' # can't require this :(
Row = require '../row'
settings = require '../settings'


Grid = React.createClass

  shouldComponentUpdate: ->
    @props.mamba.moving()

  propTypes:
    reset: React.PropTypes.bool.isRequired
    mamba: React.PropTypes.any.isRequired
    collided: React.PropTypes.func.isRequired

  render: ->
    range = settings.GRID.range()
    <div className="grid">
      {<Row {... @props} row={row} key={"row-#{row}"} /> for row in range}
    </div>


__GRID__ = null

module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if __GRID__?
      throw new Error("Grid's already been rendered!")
    __GRID__ = React.render <Grid {... props}/>, @_html_element

  # This is supposed to be an anti-pattern, but I
  # don't find it difficult to reason about.
  #
  # https://facebook.github.io/react/docs/component-api.html
  set_props: (props, callback) ->
    if !__GRID__?
      throw new Error("Grid hasn't been rendered!")
    __GRID__.setProps(props, callback)