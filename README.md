## mamba. ##

An implementation of a classic game using [Flux](https://facebook.github.io/flux/), [React](https://facebook.github.io/react/), and [immutable-js](https://facebook.github.io/immutable-js/).

[![Deployed to Heroku](https://heroku-badge.herokuapp.com/?app=maaamba)](https://maaamba.herokuapp.com/)

Served from Heroku; click the badge above to try it out.

### Architecture & Implementation

There's one Dispatcher, a few Actions, and a couple of Stores evolving and feeding data 
uni-directionally to React components.

Because the models are backed by [immutable data structures](https://facebook.github.io/immutable-js/docs/#/), 
change-detection and component rendering are fast and efficient.

Developed in [coffee-react](https://github.com/jsdf/coffee-react). Sources are served minified (with sourcemaps) in production.

### Gameplay

The goal is to collide with as many green squares as the score counter suggests, without hitting any 
black squares, or self-intersecting. 

#### Instructions & Rules

* press `R` to restart
* use the arrow keys (`←`, `↑`, `→`, `↓`) to move around
* reversing directions while moving isn't allowed


### Support

Feedback? [Get in touch.](https://github.com/yangmillstheory)
