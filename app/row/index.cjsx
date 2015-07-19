React = require('react');
Cell = require('../cell');
_ = require('underscore');


Row = React.createClass

  render: ->
    cells = _.times @props.row_length, ->
      <Cell />

    <div className="row">{cells}</div>


module.exports = Row;