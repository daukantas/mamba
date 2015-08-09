Random = require 'random-js'
engine = Random.engines.mt19937().autoSeed()


module.exports =

  int: (min, max) ->
    Random.integer(min, max)(engine)

  shuffle: (array) ->
    Random.shuffle(engine, array)