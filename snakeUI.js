// var _u = require('underscore');

var SnakeUI = (function () {

  var Game = function () {
    this.board = new SnakeBoard();
    this.render();
    this.setClickListener();
  }

  Game.prototype.render = function () {
    var that = this;

    $("body").append($('<div class="board"></div>'));
    return _.times(10, function (i) {
      var $row = $('<div class="row" id="row' + i + '"></div>')
      $(".board").append($row);
      return _.times(10, function (j) {
        var $cell = $('<div class="col" id="cell' + i + j + '"></div>')

        if (_.isEqual(that.board.head, {x: i, y: j})) {
          $cell.text("H");
        } else if (that.board.hasSeg({x: i, y: j})) {
          $cell.text("S");
        } else if (that.board.hasApple({x: i, y: j})) {
          $cell.text("A");
        }

        $("#row" + i).append($cell);
      });
    });
  }

  Game.prototype.setClickListener = function () {
    var that = this;
    $(".col").on('click', function () {
      var posMatch = this.id.match(/cell(\d)(\d)/);
      that.makeMove(posMatch[1], posMatch[2]);
      console.log(posMatch[1], posMatch[2]);
    });
  }

  Game.prototype.makeMove = function (i, j) {
    var x = i - this.board.head.x,
        y = j - this.board.head.y;

    if (this.board.isValidDir(x, y)) {
      this.board.moveHead(x, y);
      $("body").empty();

      this.render();
      this.messageIfWon();
      this.messageIfLose();
      this.setClickListener();
    }
  }

  Game.prototype.messageIfWon = function () {
    if (this.board.won()) {
      var $winMsg = $('<div class="endmsg">You won!!!</div>');
      $("body").append($winMsg);
      $(".col").off("click");
    }
  }

  Game.prototype.messageIfLose = function () {
    if (this.board.lose()) {
      var $loseMsg = $('<div class="endmsg">You lose.</div>');
      $("body").append($loseMsg);
      $(".col").off("click");
    }
  }

  return Game;
})();