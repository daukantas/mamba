Random = require 'random-js'

engine = Random.engines.mt19937().autoSeed()

module.exports =

  # Return a random integer between 0 and max inclusive.
  int: (min, max) ->
    Random.integer(min, max)(engine)