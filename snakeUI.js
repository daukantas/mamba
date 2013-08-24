var SnakeUI = (function () {

  var Game = function () {
    this.board = new SnakeBoard();
    this.render();   
    this.setInterval();
    this.impulse = {x: 0, y: 0};
    this.IMPULSES = { "up": {x: -1, y: 0},
                      "down": {x: 1, y: 0},
                      "left": {x: 0, y: -1},
                      "right": {x: 0, y: 1} }
  }

  Game.prototype.setInterval = function () {
    var that = this;

    this.interval = window.setInterval(function () {
        that.setImpulse.apply(that);
        var impulse = that.impulse;

        that.makeMove(impulse);
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
      this.impulse = this.IMPULSES.up; 
    } else if (key.isPressed("down")) {
      this.impulse = this.IMPULSES.down;
    } else if (key.isPressed("left")) {
      this.impulse = this.IMPULSES.left; 
    } else if (key.isPressed("right")) {
      this.impulse = this.IMPULSES.right; 
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

  Game.prototype.makeMove = function (impulse) {
    this.board.moveHead(impulse.x, impulse.y;
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