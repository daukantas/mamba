React = require 'react'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

{LEVEL} = require '../../settings'
{GridEvolver} = require '../../stores'


Score = React.createClass

  statics:
    scored_class: 'scored'

  getInitialState: ->
    current_score: 0, desired_score: LEVEL.max_score(), scored_class: ''

  componentWillMount: ->
    GridEvolver.add_score_listener @_on_score

  _on_score: (ev) ->
    if ev.increment
      @setState
        current_score: (@state.current_score + 1)
        scored_class: @constructor.scored_class
    else if ev.reset
      @setState current_score: 0, scored_class: ''

  _pad_score: (score) ->
    (score < 10 && "0#{score}") || "#{score}"

  componentDidUpdate: ->
    if (@state.scored_class is @constructor.scored_class) && !@_won()
      setTimeout =>
        @setState scored_class: ''
        @forceUpdate()
      , 500

  _won: ->
    @state.current_score is @state.desired_score

  render: ->
    flash_all_components = @_won()
    others_extra_classes = (flash_all_components && @state.scored_class) || ''

    <ReactCSSTransitionGroup transitionName='fading-in' transitionAppear={true}>
      <div className="score">
        <span ref="current_score" className="score-current #{@state.scored_class}">
          {@_pad_score @state.current_score}
        </span>
        <span className="score-slash #{others_extra_classes}">
          /
        </span>
        <span className="score-desired #{others_extra_classes}">
          {@_pad_score @state.desired_score}
        </span>
      </div>
    </ReactCSSTransitionGroup>


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