var React = require('react');
var Cell = require('./cell');
var _ = require('underscore');


var Row = React.createClass({displayName: "Row",

  render: function() {
    var cells = _.times(this.props.row_length, function() {
      return React.createElement(Cell, null);
    });

    return (
      React.createElement("div", {className: "row"}, cells)
    );
  }

});

module.exports = Row;