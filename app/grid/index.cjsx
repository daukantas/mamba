React = require 'react'
_ = require 'underscore'

Snake = require '../snake' # can't require this :(
Row = require '../row'
Cell = require '../cell'
{GRID} = require '../settings'
game_over = require '../util/game-over' # again, can't require the top-level module



Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool.isRequired
    snake: React.PropTypes.any.isRequired

    game_over: React.PropTypes.oneOf([
      game_over.failure
      game_over.success
    ])

    on_smash: React.PropTypes.func.isRequired
    on_reset: React.PropTypes.func.isRequired

  statics:
    out_of_bounds: (snake) ->
      head = snake.head()
      head.x < 0 ||
      head.y < 0 ||
      head.x >= GRID.dimension ||
      head.y >= GRID.dimension

  shouldComponentUpdate: (next_props) ->
    if next_props.game_over?
      true
    else if next_props.reset
      true
    else
      @props.snake.moving()

  componentWillReceiveProps: (next_props) ->
    # Saving this in @state fails; it won't be "ready"
    # in shouldComponentUpdate. Note that this isn't
    # really a Cell.Wall collision - the boundary is
    # artificial.
    if next_props.reset
      @_Items_received = 0
    out_of_bounds = @constructor.out_of_bounds(next_props.snake)
    if @_no_loss(next_props) && out_of_bounds
      @props.on_smash Cell.Wall

  _no_loss: (next_props) ->
    !next_props.game_over? || next_props.game_over.success

  _on_row_reset: (row_items) ->
    @_Items_received += row_items

  componentDidUpdate: ->
    if @props.reset
      @_submit_total_Items()

  componentDidMount: ->
    @_submit_total_Items()

  _submit_total_Items: ->
    @props.on_reset(@_Items_received)

  render: ->
    {reset, snake, on_smash, game_over} = @props
    on_reset = @_on_row_reset

    <div className="grid">
      {for row in GRID.range()
        <Row on_reset={on_reset} reset={reset} row={row} game_over={game_over}
             on_smash={on_smash} snake={snake} key={"row-#{row}"} />}
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