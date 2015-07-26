module.exports =

  # Return a random integer between 0 and max inclusive.
  int: (min, max) ->
    # implementation:
    #
    #   - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    Math.floor(Math.random() * (max - min + 1)) + 1;