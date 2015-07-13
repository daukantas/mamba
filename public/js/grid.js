var React = require('react');
var Row = require('./row');

var Grid = React.createClass({displayName: "Grid",

  defaultProps: function() {
    return {dimension: 50};
  },

  render: function() {
    return (
      React.createElement("div", {class: "grid"}, 
        React.createElement(Row, null), 
        React.createElement(Row, null), 
        React.createElement(Row, null)
      )
    );
  }
});


React.render(React.createElement(Grid, null), document.getElementById('mamba'));