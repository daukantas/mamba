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
        that.makeMove(impulse.x, impulse.y);
        that.render();

        if (that.lose()) {
          that.loseAction();
        } else if (that.won()) {
          that.wonAction();
        }
    }, 200);
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
    return _.times(10, function (i) {
      var $row = $('<div class="row" id="row' + i + '"></div>')
      $(".board").append($row);
      return _.times(10, function (j) {
        var $cell = $('<div class="col" id="cell' + i + j + '"></div>')

        if (_.isEqual(that.board.head, {x: i, y: j})) {
          $cell.removeClass("col").addClass("head");
        } else if (that.board.hasSeg({x: i, y: j})) {
          $cell.removeClass("col").addClass("segment");
        } else if (that.board.hasApple({x: i, y: j})) {
          $cell.removeClass("col").addClass("apple");
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
    $("body").append($winMsg);
    clearInterval(this.interval);
  }

  Game.prototype.loseAction = function () {
    var $loseMsg = $('<div class="endmsg">You lose.</div>');
    $("body").append($loseMsg);
    clearInterval(this.interval);
  }

  return Game;
})();