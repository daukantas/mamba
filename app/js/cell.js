var React = require('react');


var Cell = React.createClass({displayName: "Cell",
    render: function() {
      return (React.createElement("div", {className: "cell"}, "Cell"));
    }
});

module.exports = Cell;