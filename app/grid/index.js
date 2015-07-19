var React = require('react');
var Row = require('../row');
var _ = require('underscore');

var Grid = React.createClass({displayName: "Grid",

  getDefaultProps: function() {
    return {dimension: 50};
  },

  render: function() {
    var rows = _.times(this.props.dimension, function() {
      return React.createElement(Row, {row_length: this.props.dimension})
    }, this);

    return (
      React.createElement("div", {className: "grid"}, rows)
    );
  }
});


React.render(React.createElement(Grid, null), document.getElementById('mamba'));