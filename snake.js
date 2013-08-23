var Snake = (function () {

	function Segment (x, y) {
		this.x = x;
		this.y = y;
		this.child = null;
	}

	function Board () {
		this.dim = 10;
		this.head = new Segment(4, 4);
		this.lastDirection = { x: 0, y: 0 };
		this.apples = [];
		this.randomApples();
	};

	Board.prototype.apple = function (x, y) {
		this.apples.push({x: x, y: y});
	}

	Board.prototype.randomApples = function () {
		var i = 0;
		while (i < 5) {
			var randomX = Math.floor(Math.random() * 10);
			var randomY = Math.floor(Math.random() * 10);
			if (this.head.x != randomX || 
					this.head.y != randomY) {
				this.apple(randomX, randomY);
				i++;
			}
		}
	}

	Board.prototype.moveHead = function (x, y) {
		var pos = {x: this.head.x + x,
							 y: this.head.y + y};

		if (this.isInvalidDir(x, y)) {
			console.log("Invalid move!");
			return;
		} else if (this.hasApple(pos)) {
			console.log("adding segment");
			this.slide(x, y);
			this.addSegment();
			this.destroyApple(pos);
		} else {
			this.slide(x, y);
		}
	}

	Board.prototype.destroyApple = function (pos) {
		for (var i = 0; i < this.apples.length; i++) {
			var apple = this.apples[i];
			if (apple.x === pos.x && apple.y === pos.y) {
				this.apples.splice(i, 1);
			}
		}
	}

	Board.prototype.isInvalidDir = function (x, y) {
		var pos = {x: this.head.x + x,
							 y: this.head.y + y};

		if (x == -this.lastDirection.x &&
			  y == -this.lastDirection.y) {
			return true;
		} else if (Math.max(pos.x, pos.y) > this.dim - 1 || 
							 Math.min(pos.x, pos.y) < 0) {
			return true;
		}

		return false;
	}

	Board.prototype.hasApple = function (pos) {
		for (var i = 0; i < this.apples.length; i++) {
			var apple = this.apples[i];
			if (apple.x === pos.x && apple.y === pos.y) {
				return true;
			}
		}

		return false;
	}

	Board.prototype.hasSeg = function(pos) {
		var runner = this.head;

		while (runner) {
			if (runner.x == pos.x && runner.y == pos.y) {
				return true;
			}

			runner = runner.child;
		}

		return false;
	}

	Board.prototype.slide = function (x, y) {
		console.log("sliding!");
		var runner = this.head;

		while (runner.child != null) {
			runner.child.x = runner.x;
			runner.child.y = runner.y;
			runner = runner.child;
		}

		this.head.x += x;
		this.head.y += y;
		this.lastDirection = { x: x, y: y };
	}

	Board.prototype.addSegment = function () {
		console.log("in add segment");

		var runner = this.head;
		while (runner.child != null) {
			runner = runner.child;
		}

		runner.child = new Segment(runner.x - this.lastDirection.x,
															 runner.y - this.lastDirection.y);
	}

	Board.prototype.render = function () {
		var str = "";

		for (var i = 0; i < this.dim; i++) {
			for (var j = 0; j < this.dim; j++) {
				
				// Poor performance!
				if (this.hasApple({x: i, y: j})) {
					str += " A ";
				} else if (this.hasSeg({x: i, y: j})) {
					str += " * ";
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

	Board.prototype.won = function () {
		return this.apples.length == 0;
	}

	return { Board: Board,
					 Segment: Segment }
})();

var g = Snake;
var b = new g.Board();
b.render();
b.moveHead(1, 0);
b.render();
b.moveHead(0, 1);
b.render();
b.moveHead(0, 1);
b.render();
b.moveHead(0, 1);
b.render();
b.moveHead(-1, 0);
b.render();
b.moveHead(0, 1);
b.render();
b.moveHead(0, 1);
b.render();




