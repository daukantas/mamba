var SnakeBoard = (function () {

  function SnakeBoard (dim, numApples, numWalls) {
    this.dim = dim;
    this.valid_dirs();
    this.lastDirection = { x: 0, y: 0 };

    this.snake = [{x: this.dim / 2 - 1, y: this.dim / 2 - 1}];
    this.head = _.first(this.snake);
    this.randomApples(numApples);
    this.randomWalls(numWalls);
  };

  SnakeBoard.prototype.valid_dirs = function () {
    this.VALID_DIRS = [];
    var that = this;
    _.each([-1, 1], function(u) {
      that.VALID_DIRS.push({x: u, y: 0});
      that.VALID_DIRS.push({x: 0, y: u});
    })
  }

  // Apples are generated many times.
  SnakeBoard.prototype.randomApples = function (numApples) {
    this.apples = [];

    var i = 0;
    while (i < numApples) {
      var randX = _.random(0, this.dim - 1);
      var randY = _.random(0, this.dim - 1);

      var apple = {x: randX, y: randY};
      if (this.doesntOverlap("apples", apple) && 
          this.doesntOverlap("walls", apple) && 
          this.doesntOverlap("snake", apple)) {
        this.apples.push(apple);
        i++;
      }
    }
  }

  // Walls are generated once at initialization.
  SnakeBoard.prototype.randomWalls = function (numWalls) {
    this.walls = [];
    
    var i = 0;
    while (i < numWalls) {
      var randX = _.random(0, this.dim -1);
      var randY = _.random(0, this.dim -1);

      var wall = {x: randX, y: randY};
      if (!_.isEqual(this.head, wall) && 
          this.doesntOverlap("apples", wall) &&
          this.doesntOverlap("walls", wall)) {
        this.walls.push(wall);
        i++;
      }
    }
  }

  SnakeBoard.prototype.doesntOverlap = function (type, pos) {
    var that = this;
    return _.every(this[type], function (type) {
      return !_.isEqual(type, pos);
    })
  }

  SnakeBoard.prototype.destroyApple = function (pos) {
    this.apples = _.reject(this.apples, function(ap) {
      return _.isEqual(ap, pos);
    });
  }

  SnakeBoard.prototype.valid_dir = function (impulse) {
    var x = impulse.x,
        y = impulse.y;

    var that = this;
    return _.some(this.VALID_DIRS, function (dir) {
      return _.isEqual(dir, {x: x, y: y});
    })
  }

  SnakeBoard.prototype.validImpulse = function (impulse) {
    var pos = {x: this.head.x + impulse.x,
               y: this.head.y + impulse.y};

    if (impulse.x == -this.lastDirection.x &&
        impulse.y == -this.lastDirection.y) {
      return false;
    } else if (!this.valid_dir(impulse)) {
      return false;
    }
    return true;
  }

  SnakeBoard.prototype.hasApple = function (pos) {
    var that = this;
    return _.some(this.apples, function(apple) {
      return _.isEqual(apple, pos);
    })
  }

  SnakeBoard.prototype.hasSeg = function (pos) {
    var that = this;
    return _.some(this.snake, function (seg) {
      return _.isEqual(seg, pos);
    })
  }

  SnakeBoard.prototype.hasWall = function (pos) {
    var that = this;
    return _.some(this.walls, function (wall) {
      return _.isEqual(pos, wall);
    })  
  }

  SnakeBoard.prototype.moveHead = function (impulse) {
    this.impulse = {x: this.head.x + impulse.x,
                    y: this.head.y + impulse.y};

    if (this.hasApple(this.impulse)) {
      this.slide(impulse);
      this.pushSegment();
      this.destroyApple(this.impulse);
    } else {
      this.slide(impulse);
    }

    this.lastDirection = impulse;
  }

  SnakeBoard.prototype.slide = function (impulse) {
    for (var i = this.snake.length - 1; i > 0; i--) {
      this.snake[i].x = this.snake[i - 1].x;
      this.snake[i].y = this.snake[i - 1].y;
    }

    this.head.x += impulse.x;
    this.head.y += impulse.y;
  }

  SnakeBoard.prototype.pushSegment = function () {
    var tail = _.last(this.snake);

    this.snake.push({
      x: tail.x - this.lastDirection.x,
      y: tail.y - this.lastDirection.y
    });
  }

  SnakeBoard.prototype.render = function () {
    var str = "";
    var pos = {x: i, y: j};

    for (var i = 0; i < this.dim; i++) {
      for (var j = 0; j < this.dim; j++) {
        
        if (this.hasApple(pos)) {
          str += " A ";
        } else if (_.isEqual(this.head, pos)){
          str += " H ";
        } else if (this.hasSeg(pos)) {
          str += " S ";
        } else if (this.hasWall(pos)) {
          str += " W ";
        } else {
          str += " _ ";
        }

        if (j == this.dim - 1) {
          str += "\n";
        }
      }
    }

    console.log(str);
  }

  SnakeBoard.prototype.selfCollision = function () {
    if (this.snake.length < 5) {
      return false;
    }

    var that = this;
    var dups = _.select(this.snake, function (seg) {
      return _.isEqual(seg, that.impulse);
    });

    return dups.length > 1;
  }

  SnakeBoard.prototype.outerwallCollision = function () {
    return (Math.max(this.impulse.x, this.impulse.y) > this.dim - 1 || 
            Math.min(this.impulse.x, this.impulse.y) < 0);
  }

  SnakeBoard.prototype.innerWallCollision = function () {
    var that = this;

    return _.some(this.walls, function (wall) {
      return _.isEqual(wall, that.impulse);
    });
  }

  SnakeBoard.prototype.wallCollision = function () {
    return this.innerWallCollision() || this.outerwallCollision();
  }

  SnakeBoard.prototype.lose = function () {
    return this.wallCollision() || this.selfCollision();
  }

  return SnakeBoard;
})();