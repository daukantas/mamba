React = require('react');
Cell = require('../cell');
_ = require('underscore');


Row = React.createClass

  # TODO: implement me.
  #
  #   - if the player is close (based on head and length), don't re-render
  #
  shouldComponentUpdate: ->
    true

  propTypes:
    cells: React.PropTypes.array
    row: React.PropTypes.number.isRequired

  # TODO:
  #
  #   - if reset, re-render
  #
  render: ->
    {row, cells} = @props

    <div className="row">
      {(<Cell key="cell-#{row}-#{col}"} content={cell}/> for cell, col in cells)}
    </div>


module.exports = Row;