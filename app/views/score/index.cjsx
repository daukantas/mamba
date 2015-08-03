React = require 'react'

{LEVEL} = require '../../settings'
{GridEvolver} = require '../../stores'


Score = React.createClass

  getInitialState: ->
    current_score: 0, desired_score: LEVEL.max_score()

  componentWillMount: ->
    GridEvolver.add_score_listener @_on_score

  _on_score: (ev) ->
    if ev.increment
      @setState current_score: (@state.current_score + 1)
    else if ev.reset
      @setState current_score: 0

  _pad_score: (score) ->
    (score < 10 && "0#{score}") || "#{score}"

  render: ->
    <div className="score">
      <span className="score-current">{@_pad_score(@state.current_score)}</span>
      <span className="score-slash">/</span>
      <span className="score-desired">{@state.desired_score}</span>
    </div>


__Score__ = null


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
        throw new Error("Mount HTMLElement before rendering!")
      else if __Score__?
        throw new Error("Score's already been rendered!")
      __Score__ = React.render <Score />, @_html_element