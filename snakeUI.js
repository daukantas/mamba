var SnakeUI = (function () {

  var Game = function (opts) {
    this.board = new SnakeBoard(opts.dim, 
      opts.numApples, 
      opts.numWalls
    );

    this.dim = opts.dim;
    this.numWalls = opts.numWalls;
    this.numApples = opts.numApples;
    this.timeStep = opts.timeStep;
    
    this.initDisplay();

    this.setInterval(opts.timeStep);
    this.impulse = {x: 0, y: 0};

    this.IMPULSES = { 
      "up": {x: -1, y: 0},
      "down": {x: 1, y: 0}, 
      "left": {x: 0, y: -1}, 
      "right": {x: 0, y: 1} 
    }

    this.streak = 0;
  }

  Game.prototype.setInterval = function (timeStep) {
    var that = this;

    this.interval = window.setInterval(function () {
        that.setImpulse.apply(that);
        that.makeMove(that.impulse);
        that.updateBoard();

        if (that.lose()) {
          clearTimeout(that.timeout);
          clearInterval(that.interval);
          that.displayMessage("game over!<br/>press 'r' to restart.");
          that.promptRestart();
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
    var $score = $('<p id="score">score: 0</p>');
    var $streak = $('<p id="streak">streak: 0</p>');
    var $message = $('<p id="message"></p>');

    $("body").append($sidebar);
    $("#sidebar").append($content);
    $("#content").append($score);
    $("#content").append($streak);
    $("#content").append($message);
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

    if (!this.board.apples.length) {
      this.displayMessage("great job!");
      this.repopulateApples();
      this.shuffleWalls();
      this.streak++;
    } 

    this.updateScore();
    this.updateStreak();
  }

  Game.prototype.updateScore = function () {
    var score = this.numApples * (this.streak + 1) - this.board.apples.length;

    $("#score").html("score: " + score);
  }

  Game.prototype.updateStreak = function () {
    $("#streak").html("streak: " + this.streak);
  }

  Game.prototype.repopulateApples = function () {
    this.board.randomApples(this.numApples);
  }

  Game.prototype.displayMessage = function (msg) {
    var that = this;
    var times = 5;

    var flash = function() {
      $("#message").html(msg);
      times--;

      if (times == 0) {
        return;
      }

      window.setTimeout(function () {
        $("#message").html("");
        flash();
      }, 2000);
    }

    flash();
  }

  // 'r' keycode: 114.
  Game.prototype.promptRestart = function () {
    var that = this;

    $(window).keypress(function (ev) {
      if (ev.which == 114) {
        that.restart.apply(that);
        $(window).off('keypress');
     }
    })
  }

  Game.prototype.restart = function () {
    opts = {
      dim: this.dim,
      numWalls: this.numWalls,
      numApples: this.numApples,
      timeStep: this.timeStep 
    }

    $("body").empty();
    clearTimeout(this.timeout);
    new Game(opts);
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

  return Game;
})();