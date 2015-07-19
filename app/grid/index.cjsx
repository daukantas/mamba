React = require('react');
Row = require('../row');
_ = require('underscore');

Grid = React.createClass

  getDefaultProps: ->
    dimension: 50

  render: ->
    rows = _.times(@props.dimension, ->
      <Row row_length={@props.dimension} />
    , @)

    <div className="grid">{rows}</div>


React.render <Grid />, document.getElementById('mamba');