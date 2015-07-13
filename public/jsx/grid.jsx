var React = require('react');
var Row = require('./row');
var _ = require('underscore');

var Grid = React.createClass({

  getDefaultProps: function() {
    return {dimension: 50};
  },

  render: function() {
    var rows = _.times(this.props.dimension, function() {
      return <Row row_length={this.props.dimension} />
    }, this);

    return (
      <div className="grid">{rows}</div>
    );
  }
});


React.render(<Grid />, document.getElementById('mamba'));