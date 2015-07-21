React = require('react');
{Cell} = require('../cell');
_ = require('underscore');


Row = React.createClass

  # TODO: implement me. You shouldn't always have to re-render...
  shouldComponentUpdate: ->
    true

  render: ->
    cells = _.times @props.length, ->
      <Cell content={Cell.Grub}/>

    <div className="row">{cells}</div>


module.exports = Row;