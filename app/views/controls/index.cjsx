React = require 'react'
{CellStore} = require '../../stores'


Controls = React.createClass

  render: ->
    <div className="key-controls">
      <RestartKey></RestartKey>
      <LeftKey></LeftKey>
      <UpKey></UpKey>
      <RightKey></RightKey>
      <DownKey></DownKey>
    </div>


__CONTROLS__ = null

module.exports =

  mount: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if __CONTROLS__?
      throw new Error("Grid's already been rendered!")
    __CONTROLS__ = React.render <Controls {... props}/>, @_html_element