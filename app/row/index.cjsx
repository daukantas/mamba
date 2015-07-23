React = require('react');
{Cell} = require('../cell');
_ = require('underscore');


Row = React.createClass

  # TODO: implement me. You shouldn't always have to re-render...
  shouldComponentUpdate: ->
    true

  render: ->
    cells = _.times @props.length, ->
      random = Math.random()
      if random < .25
        content = Cell.Item
      else if random < .50
        content = Cell.Void
      else if random < .75
        content = Cell.Wall
      else
        content = Cell.Snake
      <Cell content={content}/>

    <div className="row">{cells}</div>


module.exports = Row;