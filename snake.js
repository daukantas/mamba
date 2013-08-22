var Snake = (function () {

	function Segment (x, y) {
		this.x = x;
		this.y = y;
		this.child = null;
	}

	function Board () {
		this.dim = 10;
		this.head = new Segment(4, 4);
		this.lastDirection = null;
		
		this.apples = [];
	};

	Board.apple = function (x, y) {
	}

	Board.prototype.move = function (x, y) {
		var pos = {x: this.head.x + x,
							 y: this.head.y + y};

		if (this.isInvalidDir(pos)) {
			console.log("Invalid move!");
			return;
		} else if (this.hasApple(pos)) {
			this.addSegment(pos);
		}

		this.slide(x, y);
	}

	Board.prototype.isInvalidDir = function (pos) {
		if (pos.x == -this.lastDirection.x &&
			  pos.y == -this.lastDirection.y) {
			return false;
		} else if (Math.max(pos.x, pos.y) > this.dim - 1 || 
							 Math.min(pos.x, pos.y) < 0) {
			return false;
		}

		return true;
	}

	Board.prototype.hasApple = function (pos) {
		for (var i = 0; i < this.apples.length; i++) {
			var apple = this.apples[i];
			if (apple.x === newPos.x && apple.y === newPos.y) {
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
		var runner = this.head;

		while (runner.child) {
			runner.child.x = runner.x;
			runner.child.y = runner.y;
		}

		this.head.x += x;
		this.head.y += y;
	}

	Board.prototype.addSegment = function (pos) {
		var newHead = new Segment(pos.x, pos.y);
		newHead.child = this.head;
		this.head = newHead;
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

	return { Board: Board,
					 Segment: Segment }
})();

var g = Snake;
var b = new g.Board();
b.render();
