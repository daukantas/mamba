React = require 'react'
Row = require '../row'

{LEVEL} = require '../../settings'
{GridEvolver} = require '../../stores'


Score = React.createClass

  getInitialProps: ->
    max: LEVEL.rounds_to_win

  getInitialState: ->
    score: 0

  componentDidMount: ->
    GridEvolver.add_score_listener @_on_change

  _on_change: (score) ->
    @setState {score}

  render: ->
    <div className="score">
      {@state.score}
    </div>


__Grid__ = null


module.exports = Object.create null,

  _html_element:
    writable: true
    value: ->
      @_html_element

  mount:
    enumerable: true
    value: (@_html_element) ->
      @

  render:
    enumerable: true
    value: ->
      if !@_html_element?
        throw new Error("Set HTMLElement html_element before rendering!")
      else if __Grid__?
        throw new Error("Grid's already been rendered!")
      __Grid__ = React.render <Grid />, @_html_element