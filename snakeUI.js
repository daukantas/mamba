// var _u = require('underscore');

var SnakeUI = (function () {

  var Game = function () {
    this.board = new SnakeBoard();
    this.render();
    // this.setClickListener();
    this.setInterval();
    this.impulse = {x: 0, y: 0};
  }

  Game.prototype.setInterval = function () {
    var that = this;
    this.interval = window.setInterval(function () {
        that.setImpulse.apply(that);
        var impulse = that.impulse;
        that.board.impulse = impulse;
        // console.log(that.impulse);

        that.makeMove(impulse.x, impulse.y);
        that.render();

        if (that.lose()) {
          that.loseAction();
        } else if (that.won()) {
          that.wonAction();
        }
    }, 100);
  }

  Game.prototype.setImpulse = function () {
    if (key.isPressed("up")) {
      console.log("up");
      this.impulse = {x: -1, y: 0};
    } else if (key.isPressed("down")) {
      console.log("down");
      this.impulse = {x: 1, y: 0};
    } else if (key.isPressed("left")) {
      console.log("left");
      this.impulse = {x: 0, y: -1};
    } else if (key.isPressed("right")) {
      console.log("right");
      this.impulse = {x: 0, y: 1};
    }
  }

  Game.prototype.render = function () {
    $("body").empty();
    var that = this;

    $("body").append($('<div class="board"></div>'));
    return _.times(20, function (i) {
      var $row = $('<div class="row" id="row' + i + '"></div>')
      $(".board").append($row);
      return _.times(20, function (j) {
        var $cell = $('<div class="col"></div>');
        var pos = {x: i, y: j};

        if (_.isEqual(that.board.head, pos)) {
          $cell.attr("id", "head");
        } else if (that.board.hasSeg(pos)) {
          $cell.attr("id", "segment");
        } else if (that.board.hasWall(pos)) {
          $cell.attr("id", "wall");
        } else if (that.board.hasApple(pos)) {
          $cell.attr("id", "apple");
        }

        $("#row" + i).append($cell);
      });
    });
  }

  // Game.prototype.setClickListener = function () {
  //   var that = this;
  //   $(".col").on('click', function () {
  //     var posMatch = this.id.match(/cell(\d)(\d)/);
  //     that.makeMove(posMatch[1], posMatch[2]);
  //     console.log(posMatch[1], posMatch[2]);
  //   });
  // }

  Game.prototype.makeMove = function (x, y) {
    // var x_ = x - this.board.head.x,
    //     y_ = y - this.board.head.y;

    this.board.moveHead(x, y);
  }

  Game.prototype.lose = function () {
    return this.board.lose();
  }

  Game.prototype.won = function () {
    return this.board.won();
  }

  Game.prototype.wonAction = function () {
    var $winMsg = $('<div class="endmsg">You win!</div>');
    $("body").prepend($winMsg);
    clearInterval(this.interval);
  }

  Game.prototype.loseAction = function () {
    var $loseMsg = $('<div class="endmsg">You lose.</div>');
    $("body").prepend($loseMsg);
    clearInterval(this.interval);
  }

  return Game;
})();