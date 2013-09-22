var SnakeGame = (function () {

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
    game.winStreak = opts.winStreak;
    game.streak = 0;

    console.log(game.winStreak)

    // Keys are key-codes.
    game.IMPULSES = { 
      38: {x: -1, y: 0},
      40: {x: 1, y: 0}, 
      37: {x: 0, y: -1}, 
      39: {x: 0, y: 1} 
    };

    // Player is initially static.
    game.impulse = {x: 0, y: 0};
    
    game.bindKeys();
    game.populateBoard(function () {
      game.setInterval(opts.timeStep);
    });
  }

  Game.prototype.setInterval = function (timeStep) {
    var game = this;

    game.interval = window.setInterval(function () {

        game.makeMove.apply(game, [ game.impulse ]);
        game.updateBoard.apply(game);
        game.checkGameOver.apply(game);

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

  Game.prototype.populateBoard = function (callback) {
    var game = this;

    $("#sidebar").hide();
    game.setSizes();

    var $row;
    var $cell;

    _.each(_.range(game.dim), function (i) {
      $row = $('<div class="board-row"></div>')
      $row.attr("id", i)

      $(".board").append($row);
      game.populateRow.apply(game, [ $row, i ])
    });

    game.reveal(callback);
  }

  Game.prototype.populateRow = function ($row, row_index) {
    var game = this;

    _.each(_.range(game.dim), function (j) {
      var pos = { x: row_index, y: j };

      $cell = $('<div class="board-col"></div>');
      $cell.attr("id", j)
      $cell.css({
        "min-height": game.cell_size  + "px", 
        "min-width": game.cell_size  + "px"
      });

      game.colorCell($cell, pos)

      $row.append($cell);
      $row.css("visibility", "hidden")
    });
  }

  Game.prototype.reveal = function (callback) {
    var game = this;

    $("#sidebar").fadeIn("slow")

    function renderRow(row) {
      if (row >= game.dim / 2) {
        callback();
      } else {
        $("#" + row + ".board-row").css("visibility", "visible")
                                   .hide().fadeIn(100, function () {
          $("#" + (game.dim - row - 1) + ".board-row").css("visibility", "visible")
                                                      .hide().fadeIn(100, function () {
            renderRow(++row);
          });
        });
      }
    }

    renderRow(0);
  }

  Game.prototype.setSizes = function () {
    var game = this;

    game.cell_size = window.innerHeight / (game.dim + 10);
    game.board_width = game.dim * game.cell_size  ;
    game.styleBorders();

    $(".board").css({
      "margin-left": -10 * game.cell_size  + "px",
      "margin-top": -10 * game.cell_size   + "px"
    });
  }

  Game.prototype.colorCell = function ($cell, pos) {
    var game = this;

    if (_.isEqual(game.board.head, pos)) {
      $cell.toggleClass("head");
    } else if (game.board.has("snake", pos)) {
      $cell.toggleClass("seg");
    } else if (game.board.has("walls", pos)) {
      $cell.toggleClass("wall");
    } else if (game.board.has("apples", pos)) {
      $cell.toggleClass("apple");
    } 
  }

  Game.prototype.updateBoard = function () {
    var game = this;

    _.times(game.dim, function (i) {
      _.times(game.dim, function (j) {
        var $cell = $("#" + i + ".board-row").children()[j];

        var pos = {x: i, y: j};
        if (game.board.has("apples", pos)) {
          $cell.setAttribute("class", "board-col apple");
        } else if (game.board.has("walls", pos)) {
          $cell.setAttribute("class", "board-col wall");
        } else if (_.isEqual(game.board.head, pos)) {
          $cell.setAttribute("class", "board-col head");
        } else if (game.board.has("snake", pos)) {
          $cell.setAttribute("class", "board-col seg");
        } else {
          $cell.setAttribute("class", "board-col");
        }
      })
    })

    if (!game.board.apples.length) {
      game.displayMessage("great job!");
      game.repopulateApples();
      game.shuffleWalls();

      if (game.streak < game.winStreak - 1) {
        window.setTimeout(function () {
          $(".wall").effect("pulsate", "fast")
          $(".apple").effect("pulsate", "fast")
        }, 100)
      }

      game.streak++;
    } 

    game.updateScore();
    game.updateStreak();
  }

  Game.prototype.updateScore = function () {
    var game = this;
    var prevScore = $("#score").html()
    prevScore = parseInt($("#score").html().charAt(prevScore.length - 1))

    var score = game.numApples * (game.streak + 1) - 
                                  game.board.apples.length;

    $("#score").html("SCORE: " + score);

    if (prevScore < score) {
      $("#score").fadeOut("fast", function () {
        $("#score").fadeIn("slow")
      })
    }
  }

  Game.prototype.updateStreak = function () {
    var game = this;
    var prevStreak = $("#streak").html()
    prevStreak = parseInt($("#streak").html().charAt(prevStreak.length - 1))

    $("#streak").html("STREAK: " + game.streak);

    if (prevStreak < game.streak) {
      $("#streak").fadeOut("fast", function () {
        $("#streak").fadeIn("slow")
      })
    }
  }

  Game.prototype.repopulateApples = function () {
    var game = this;
    game.board.randomApples(game.numApples);
  }

  Game.prototype.displayMessage = function (msg) {
    $("#message").html(msg);
    $("#message").hide().fadeIn("slow", function () {
      window.setTimeout(function () {
        $("#message").fadeOut("slow", function () {
          $("#message").html("");  
        });
      }, 3000)
    });
  }

  Game.prototype.checkGameOver = function () {
    var game = this;

    if (game.lose()) {

      clearInterval(game.interval);
      $(".board").effect("shake", { distance: 100 });
      game.displayMessage("Ouch!<br/>Press 'r' to restart.");
      game.promptRestart();

    } else if (game.streak === game.winStreak) {

      clearInterval(game.interval);
      game.displayMessage(
        "You won!<br/>Amazing!<br/>Press 'r' to restart."
      );

      $(".board").effect("explode", function () {
        window.setTimeout(function () {
          $(".board").fadeIn("slow")
          game.promptRestart();
        }, 3000)
      });

    }
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
    var game = this;

    opts = {
      dim: game.dim,
      numWalls: game.numWalls,
      numApples: game.numApples,
      timeStep: game.timeStep,
      winStreak: game.winStreak
    }

    $(".board").empty();
    $("#score").html("SCORE: 0").hide().fadeIn("slow");
    $("#streak").html("STREAK: 0").hide().fadeIn("slow");
    $("#message").html("");

    new Game(opts);
  }

  Game.prototype.styleBorders = function () {
    var width = window.innerWidth - this.board_width;
    var height = window.innerHeight / 2

    $("#header").css("font", "bold " + width / 20 +  "px consolas");

    $("#sidebar").css({
      "width": width / 2 + "px",
      "font": "bold " + width / 20 + "px consolas",
      "margin-top": height / 3
    });

    $("#instructions").css({
      "width": "auto",
      "font": "bold " + width / 40 + "px consolas",
      "bottom": height / 1.5
    });

    $("#score").css({
      "font": "bold " + width / 20 + "px consolas",
      "margin-top": width / 20 + "px"
    })
    $("#streak").css({
      "font": "bold " + width / 20 + "px consolas",
      "margin-top": width / 20 + "px"
    })

    $("#message").css({
      "font": "bold " + width / 20 + "px consolas",
      "margin-top": width / 20 + "px"
    })
  }

  Game.prototype.shuffleWalls = function () {
    var game = this;

    game.board.walls = [];
    game.board.randomWalls(game.numWalls);
  }

  Game.prototype.makeMove = function (impulse) {
    var game = this;
    this.board.moveHead(impulse);
  }

  Game.prototype.lose = function () {
    return this.board.lose();
  }

  Game.prototype.validImpulse = function (keycode) {
    return this.board.validImpulse(this.IMPULSES[keycode]);
  }

  return Game;
})();