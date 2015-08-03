React = require 'react/addons'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
_ = require 'underscore'

Cell = require '../cell'
Immutable = require 'immutable'

Row = React.createClass

  propTypes:
    cells: React.PropTypes.array.isRequired
    index: React.PropTypes.number.isRequired

  componentWillMount: ->
    @setState cells: Immutable.List(@props.cells)

  componentWillReceiveProps: (next_props, next_state) ->
    @setState cells: @state.cells.withMutations (mutative_cells) ->
      mutative_cells.forEach (old_cell, col) ->
        new_cell = next_props.cells[col]
        if old_cell isnt new_cell
          mutative_cells.set col, new_cell

  shouldComponentUpdate: (next_props, next_state) ->
    next_state.cells isnt @state.cells

  render: ->
    row = @props.index
    <ReactCSSTransitionGroup transitionName='fading-in' transitionAppear={true}>
      <div className="row">
          {@state.cells.map (cell, col) ->
            (<Cell key="cell-#{row}-#{col}" content={cell}/>)}
      </div>
    </ReactCSSTransitionGroup>


module.exports = Row;