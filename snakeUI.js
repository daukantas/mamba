var SnakeUI = (function () {

  var Game = function (opts) {
    this.board = new SnakeBoard(opts.dim, 
                  opts.numApples, 
                  opts.numWalls
                );

    this.numWalls = opts.numWalls;
    this.numApples = opts.numApples;

    this.dim = this.board.dim;
    this.initDisplay();

    this.setInterval(opts.timeStep);
    this.impulse = {x: 0, y: 0};

    this.IMPULSES = { 
      "up": {x: -1, y: 0},
      "down": {x: 1, y: 0}, 
      "left": {x: 0, y: -1}, 
      "right": {x: 0, y: 1} 
    }

    this.numClears = 0;
  }

  Game.prototype.setInterval = function (timeStep) {
    var that = this;

    this.interval = window.setInterval(function () {
        that.setImpulse.apply(that);
        that.makeMove(that.impulse);
        that.updateBoard();

        if (that.lose()) {
          that.loseAction();
        }
    }, timeStep);
  }

  Game.prototype.validImpulse = function (impulse) {
    return this.board.validImpulse(impulse);
  }

  Game.prototype.validKeyPress = function (dir) {
    return key.isPressed(dir) && this.validImpulse(this.IMPULSES[dir]);
  }

  Game.prototype.setImpulse = function () {
    if (this.validKeyPress("up")) {
      this.impulse = this.IMPULSES.up; 
    } else if (this.validKeyPress("down")) {
      this.impulse = this.IMPULSES.down;
    } else if (this.validKeyPress("left")) {
      this.impulse = this.IMPULSES.left; 
    } else if (this.validKeyPress("right")) {
      this.impulse = this.IMPULSES.right; 
    }
  }

  Game.prototype.createBorders = function () {
    var $sidebar = $('<div id="sidebar"></div>').html("SNAKE GAME remix");
    var $content = $('<div id="content"></div>');
    var $score = $('<p id="score">score: ' + 
                  (this.numApples - this.board.apples.length) + 
                  '</p>');

    $("body").append($sidebar);
    $("#sidebar").append($content);
    $("#content").append($score);
  }

  Game.prototype.updateScore = function () {
    var score = this.numApples * (this.numClears + 1) - this.board.apples.length;

    $("#score").html("score: " + score);
  }

  Game.prototype.initDisplay = function () {
    this.createBorders();

    var that = this;

    $("body").append($('<div class="board"></div>'));
    $("div.board").toggleClass("center");

    // Determined at run-time if varying board-size, 
    // though I'm settling on fixed size.
    $("div.board").css({
                    "width": this.dim * 35 + "px",
                    "height": this.dim * 35 + "px",
                    "margin-left": -this.dim * 35 / 2 + "px",
                    "margin-top": -this.dim * 35 / 2 + "px"
                  });

    return _.times(that.dim, function (i) {
      var $row = $('<div class="row" id="' + i + '"></div>')
      $(".board").append($row);

      return _.times(that.dim, function (j) {
        var $cell = $('<div class="col"></div>');
        var pos = {x: i, y: j};

        if (_.isEqual(that.board.head, pos)) {
          $cell.toggleClass("head");
        } else if (that.board.has("snake", pos)) {
          $cell.toggleClass("seg");
        } else if (that.board.has("walls", pos)) {
          $cell.toggleClass("wall");
        } else if (that.board.has("apples", pos)) {
          $cell.toggleClass("apple");
        } 

        $(".row#" + i).append($cell);
      });
    });
  }

  Game.prototype.updateBoard = function () {
    var that = this;

    _.times(that.dim, function (i) {
      _.times(that.dim, function (j, el) {
        var $cell = $('div.row#' + i).children()[j];

        var pos = {x: i, y: j};
        if (that.board.has("apples", pos)) {
          $cell.setAttribute("class", "col apple");
        } else if (that.board.has("walls", pos)) {
          $cell.setAttribute("class", "col wall");
        } else if (_.isEqual(that.board.head, pos)) {
          $cell.setAttribute("class", "col head");
        } else if (that.board.has("snake", pos)) {
          $cell.setAttribute("class", "col seg");
        } else {
          $cell.setAttribute("class", "col");
        }
      })
    })

    this.updateScore();

    if (!this.board.apples.length) {
      this.board.randomApples(this.numApples);
      this.numClears++;
      this.shuffleWalls();
    }
  }

  Game.prototype.shuffleWalls = function () {
    this.board.walls = [];
    this.board.randomWalls(this.numWalls);
  }

  Game.prototype.makeMove = function (impulse) {
    this.board.moveHead(impulse);
  }

  Game.prototype.lose = function () {
    return this.board.lose();
  }

  Game.prototype.loseAction = function () {
    // var $loseMsg = $('<div class="endmsg">You lose.</div>');
    // $("body").prepend($loseMsg);
    clearInterval(this.interval);
  }

  return Game;
})();
