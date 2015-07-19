var React = require('react');
var Cell = require('./cell');
var _ = require('underscore');


var Row = React.createClass({

  render: function() {
    var cells = _.times(this.props.row_length, function() {
      return <Cell />;
    });

    return (
      <div className="row">{cells}</div>
    );
  }

});

module.exports = Row;