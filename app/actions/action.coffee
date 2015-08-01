_ = require 'underscore'
errors = require '../utility'
Immutable = require 'immutable'


class Action

  @abstract_classprops = Immutable.Set([
    'name'
    'validate_payload'
  ])

  __abstract_validated = false

  constructor: (payload) ->
    if !@constructor.__abstract_validated
      if @constructor is Action
        throw new Error "Can't instantiate abstract class Action"
      else
        for classprop in @constructor.abstract_classprops
          unless @constructor[classprop]?
            throw new errors.NotImplemented("need class property `#{classprop}`")
        @constructor.__abstract_validated = true
    @payload = payload
    @

  toString: ->
    @name

  @of: (payload) ->
    @validate_payload(payload)
    new @constructor(payload)

  @is: (instance) ->
    instance.constructor is @


module.exports = Action