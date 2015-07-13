var React = require('react');
var Row = require('./row');

var Grid = React.createClass({

  defaultProps: function() {
    return {dimension: 50};
  },

  render: function() {
    return (
      <div className="grid">
        <Row />
        <Row />
        <Row />
      </div>
    );
  }
});


React.render(<Grid />, document.getElementById('mamba'));