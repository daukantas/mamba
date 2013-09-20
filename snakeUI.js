var SnakeUI = (function () {

  var Game = function (opts) {
    var game = this;

    game.board = new SnakeBoard(opts.dim, 
      opts.numApples, 
      opts.numWalls
    );

    game.dim = opts.dim;
    game.numWalls = opts.numWalls;
    game.numApples = opts.numApples;
    game.timeStep = opts.timeStep;
    
    game.initDisplay();

    game.bindKeys();
    game.setInterval(opts.timeStep);
    game.impulse = {x: 0, y: 0};

    game.IMPULSES = { 
      38: {x: -1, y: 0},
      40: {x: 1, y: 0}, 
      37: {x: 0, y: -1}, 
      39: {x: 0, y: 1} 
    };

    game.streak = 0;
  }

  Game.prototype.setInterval = function (timeStep) {
    var game = this;

    game.interval = window.setInterval(function () {
        game.makeMove(game.impulse);
        game.updateBoard();

        if (game.lose()) {
          clearTimeout(game.timeout);
          clearInterval(game.interval);
          game.displayMessage("game over!<br/>press 'r' to restart.");
          game.promptRestart();
        }

    }, timeStep);
  },

  Game.prototype.bindKeys = function () {
    var game = this;

    _.each([37, 38, 39, 40], function (keycode) {

      $(document).keydown(function (ev) {
        if (ev.which === keycode &&
            game.validImpulse.apply(game, [ keycode ])) {
          game.impulse = game.IMPULSES[keycode]
        }
      })
    })
  }

  Game.prototype.validImpulse = function (keycode) {
    return this.board.validImpulse(this.IMPULSES[keycode]);
  }

  Game.prototype.createBorders = function () {
    var $sidebar = $('<div id="sidebar"></div>').html("SNAKE GAME remix");
    var $score = $('<p id="score">score: 0</p>');
    var $streak = $('<p id="streak">streak: 0</p>');
    var $message = $('<p id="message"></p>');
    var width = window.innerWidth - this.board_width;

    $("body").append($sidebar);
    $("#sidebar").css({"width": width / 3 + "px"});
    $("#sidebar").append($score);
    $("#sidebar").append($streak);
    $("#sidebar").append($message);

    $sidebar.css({"font": "bold " + width / 20 + " consolas"})
    $score.css({"font": width / 25 + " consolas"})
    $streak.css({"font": width / 25 + " consolas"})
    $message.css({"font": width / 25 + " consolas"})
  }

  Game.prototype.initDisplay = function () {
    var game = this;
    var cell_size = window.innerHeight / (this.dim + 5);
    this.board_width = this.dim * cell_size;
    this.createBorders();

    $("body").append($('<div class="board center"></div>'));
    $(".board").css({
      "margin-left": -10 * cell_size + "px",
      "margin-top": -10 * cell_size + "px"});

    return _.times(game.dim, function (i) {
      var $row = $('<div class="row" id="' + i + '"></div>')
      $(".board").append($row);

      return _.times(game.dim, function (j) {
        var pos = {x: i, y: j};

        var $cell = $('<div class="col"></div>');
        $cell.css({"height": cell_size + "px", "width": cell_size + "px"});
        

        if (_.isEqual(game.board.head, pos)) {
          $cell.toggleClass("head");
        } else if (game.board.has("snake", pos)) {
          $cell.toggleClass("seg");
        } else if (game.board.has("walls", pos)) {
          $cell.toggleClass("wall");
        } else if (game.board.has("apples", pos)) {
          $cell.toggleClass("apple");
        } 

        $(".row#" + i).append($cell);
      });
    });
  }

  Game.prototype.updateBoard = function () {
    var game = this;

    _.times(game.dim, function (i) {
      _.times(game.dim, function (j) {
        var $cell = $('div.row#' + i).children()[j];

        var pos = {x: i, y: j};
        if (game.board.has("apples", pos)) {
          $cell.setAttribute("class", "col apple");
        } else if (game.board.has("walls", pos)) {
          $cell.setAttribute("class", "col wall");
        } else if (_.isEqual(game.board.head, pos)) {
          $cell.setAttribute("class", "col head");
        } else if (game.board.has("snake", pos)) {
          $cell.setAttribute("class", "col seg");
        } else {
          $cell.setAttribute("class", "col");
        }
      })
    })

    if (!game.board.apples.length) {
      clearTimeout(game.timeout);
      game.displayMessage("great job!");
      game.repopulateApples();
      game.shuffleWalls();
      game.streak++;
    } 

    game.updateScore();
    game.updateStreak();
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
    $("#message").html(msg);
    this.timeout = setTimeout(function () {
      $("#message").html("");
    }, 3000)
  }

  // 'r' keycode: 114.
  Game.prototype.promptRestart = function () {
    var game = this;

    $(window).keypress(function (ev) {
      if (ev.which == 114) {
        game.restart.apply(game);
        $(window).off("keypress");
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