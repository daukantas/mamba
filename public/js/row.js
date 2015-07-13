var React = require('react');
var Cell = require('./cell');

var Row = React.createClass({displayName: "Row",

  render: function() {
    return (React.createElement("div", null, "I'm a row"));
  }

});

module.exports = {Row: Row};