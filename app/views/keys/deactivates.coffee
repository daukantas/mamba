{errors} = require '../../utility'


module.exports =

  DEACTIVATE_TIMEOUT: 250

  componentWillMount: ->
    unless @_deactivate?
      throw new errors.NotImplemented "Mixing classes should implement _deactivate"
    unless @_should_deactivate?
      throw new errors.NotImplemented "Mixing classes should implement _should_deactivate"

  componentDidUpdate: ->
    if @_should_deactivate()
      # need this check to guard against infinite recursion!
      setTimeout =>
        @_deactivate()
      , @DEACTIVATE_TIMEOUT