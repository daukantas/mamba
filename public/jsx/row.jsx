var React = require('react');
var Cell = require('./cell');


var Row = React.createClass({

  render: function() {
    return (
      <div className="row">
        <Cell />
        <Cell />
        <Cell />
        <Cell />
        <Cell />
        <Cell />
      </div>
    );
  }

});

module.exports = Row;