_ = require 'underscore'
{errors} = require '../utility'
Immutable = require 'immutable'


class Action

  @abstract_classprops = Immutable.Set([
    'validate_payload'
  ])

  __abstract_validated = false

  constructor: (payload) ->
    @payload = payload
    @

  @__validate_class: ->
    if !@__abstract_validated
      if @ is Action
        throw new Error "Can't instantiate abstract class Action"
      else
        @abstract_classprops.forEach (classprop) =>
          unless @[classprop]?
            throw new errors.NotImplemented("need class property `#{classprop}`")
        @__abstract_validated = true

  toString: ->
    @constructor.name

  @of: (payload) ->
    @__validate_class()
    @validate_payload(payload)
    @post_of_hook(payload)

  # Subclass can override this
  @post_of_hook: (payload) ->
    new @(payload)

  is_a: (klass) ->
    @ instanceof klass


module.exports = Action