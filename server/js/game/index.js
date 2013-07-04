/* 
    Game logic. Mainly defines the board in which players will play
*/


(function() {
  var GameBoard, MoveNotAllowed, WIN, test;

  WIN = exports.WIN = "WIN";

  GameBoard = (function() {
    function GameBoard(players, current_player) {
      var i, j;
      this.players = players;
      this.current_player = current_player;
      this.board = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; _i <= 8; i = ++_i) {
          _results.push((function() {
            var _j, _results1;
            _results1 = [];
            for (j = _j = 0; _j <= 8; j = ++_j) {
              _results1.push(0);
            }
            return _results1;
          })());
        }
        return _results;
      })();
      this.main_board = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; _i <= 8; i = ++_i) {
          _results.push(0);
        }
        return _results;
      })();
      this.current_board = 0;
    }

    GameBoard.prototype.dumpBoard = function() {
      var board, field, i, j, m, res, _i, _j, _k, _l;
      res = ((function() {
        var _i, _results;
        _results = [];
        for (m = _i = 0; _i < 25; m = ++_i) {
          _results.push("=");
        }
        return _results;
      })()).join('') + '\n';
      for (i = _i = 0; _i <= 8; i = ++_i) {
        for (j = _j = 0; _j <= 8; j = ++_j) {
          board = (Math.floor(i / 3)) * 3 + Math.floor(j / 3);
          field = (i % 3) * 3 + j % 3;
          res += this.board[board][field];
          if (j === 2 || j === 5) {
            res += " | ";
          } else {
            res += " ";
          }
        }
        if (i === 2 || i === 5) {
          res += "\n" + ((function() {
            var _k, _results;
            _results = [];
            for (m = _k = 0; _k < 21; m = ++_k) {
              _results.push("-");
            }
            return _results;
          })()).join('') + "\n";
        } else {
          res += "\n";
        }
      }
      res += ((function() {
        var _k, _results;
        _results = [];
        for (m = _k = 0; _k < 21; m = ++_k) {
          _results.push("-");
        }
        return _results;
      })()).join('') + '\n';
      for (i = _k = 0; _k <= 2; i = ++_k) {
        for (j = _l = 0; _l <= 2; j = ++_l) {
          field = i * 3 + j;
          res += this.main_board[field];
          res += " ";
        }
        res += "\n";
      }
      res += ((function() {
        var _m, _results;
        _results = [];
        for (m = _m = 0; _m < 25; m = ++_m) {
          _results.push("=");
        }
        return _results;
      })()).join('') + '\n';
      return console.log(res);
    };

    GameBoard.prototype.allowed_turn = function() {
      return [this.current_player, this.current_board];
    };

    GameBoard.prototype.board_playable = function(board) {
      var bit, _i, _len;
      if (typeof board === 'number') {
        board = this.board[board];
      }
      for (_i = 0, _len = board.length; _i < _len; _i++) {
        bit = board[_i];
        if (bit === 0) {
          return true;
        }
      }
      return false;
    };

    GameBoard.prototype.board_finished = function(board) {
      var all, test, tests, _i, _len;
      if (typeof board === 'number') {
        board = this.board[board];
      }
      tests = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
      for (_i = 0, _len = tests.length; _i < _len; _i++) {
        test = tests[_i];
        all = board[test[0]] !== 0 && board[test[0]] === board[test[1]] && board[test[0]] === board[test[2]];
        if (all) {
          return true;
        }
      }
      return false;
    };

    GameBoard.prototype.move = function(player, board, field) {
      var player_index;
      if (this.players[0] === player) {
        player_index = 1;
      } else {
        player_index = 2;
      }
      if (player !== this.current_player) {
        throw new MoveNotAllowed("It is turn of player " + this.current_player + " not " + player);
      }
      if (this.current_board !== 0 && this.current_board !== board) {
        throw new MoveNotAllowed("You must use " + this.current_board + " board not " + board);
      }
      board -= 1;
      field -= 1;
      if (this.board[board][field] !== 0) {
        throw new MoveNotAllowed("Field " + field + " in board " + board + " already set");
      }
      this.board[board][field] = player_index;
      if (this.main_board[board] === 0) {
        if (this.board_finished(board)) {
          this.main_board[board] = player_index;
        }
      }
      player_index = player_index === 1 ? 2 : 1;
      this.current_player = this.players[player_index - 1];
      if (this.board_playable(board)) {
        this.current_board = field + 1;
      }
      this.dumpBoard();
      if (this.board_finished(this.main_board)) {
        console.log("-----------------WIN------------------");
        return WIN;
      }
    };

    return GameBoard;

  })();

  MoveNotAllowed = (function() {
    function MoveNotAllowed(message) {
      this.message = message;
    }

    MoveNotAllowed.prototype.toString = function() {
      return this.message;
    };

    return MoveNotAllowed;

  })();

  test = function() {
    var gameBoard;
    gameBoard = new GameBoard(['user1', 'user2'], 'user1');
    gameBoard.move('user1', 1, 8);
    gameBoard.move('user2', 8, 3);
    gameBoard.move('user1', 3, 3);
    gameBoard.move('user2', 3, 1);
    gameBoard.move('user1', 1, 7);
    gameBoard.move('user2', 7, 1);
    gameBoard.move('user1', 1, 9);
    gameBoard.move('user2', 9, 5);
    gameBoard.move('user1', 5, 4);
    gameBoard.move('user2', 4, 5);
    gameBoard.move('user1', 5, 6);
    gameBoard.move('user2', 6, 5);
    gameBoard.move('user1', 5, 5);
    gameBoard.move('user2', 5, 9);
    gameBoard.move('user1', 9, 3);
    gameBoard.move('user2', 3, 9);
    gameBoard.move('user1', 9, 6);
    gameBoard.move('user2', 6, 9);
    return gameBoard.move('user1', 9, 9);
  };

  test();

}).call(this);
