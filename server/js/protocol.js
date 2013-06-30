/* 
    Encapsulate protocol of socket data transmission
*/


(function() {
  var Protocol, game;

  game = require('game');

  Protocol = (function() {
    function Protocol(conn, app) {
      this.conn = conn;
      this.app = app;
      this.conn.on('data', this.onData);
      this.conn.on('close', this.close);
      this.userID = this.conn.remoteAddress + '_' + Math.random();
      this.game = null;
    }

    Protocol.prototype.onData = function(message) {
      var data, error, opponentID;
      data = this.parse(message);
      switch (data.method) {
        case 'connect':
          console.log('CONNECT');
          if (!!app.pendingConnections) {
            this.opponentConn = app.pendingConnections.pop();
            opponentID = this.opponentConn.userID;
            this.game = this.createGame(this.userID, opponentID);
            this.gameStarted(this.userID, opponentID);
            return this.opponentConn.gameStarted(opponentID, this.userID);
          } else {
            return app.pendingConnections.push(this);
          }
          break;
        case 'move':
          console.log('MOVE');
          if (!this.game) {
            return;
          }
          try {
            this.game.move(this.userID, data.data.board, data.data.field);
          } catch (_error) {
            error = _error;
            if (error instanceof game.MoveNotAllowed) {
              this.sendError(data.id, error.message);
            } else {
              throw error;
            }
            return;
          }
          this.sendOk(data.id);
          return this.opponentConn.boardChanged();
        default:
          return null;
      }
    };

    Protocol.prototype.parse = function(message) {
      return JSON.parse(message);
    };

    Protocol.prototype.stringiffy = function(data) {
      return JSON.stringiffy(data);
    };

    Protocol.prototype.createGame = function(me, opponent) {
      var newGame;
      newGame = new game.GameBoard([me, opponent], Math.random() > 0.5 ? me : opponent);
      return newGame;
    };

    Protocol.prototype.gameStarted = function() {
      var opponentID, whos_turn;
      if (this.game.players[0] === this.userID) {
        opponentID = this.game.players[1];
      } else {
        opponentID = this.game.players[0];
      }
      if (this.game.current_player === this.userID) {
        whos_turn = 0;
      } else {
        whos_turn = 1;
      }
      return this.send({
        method: 'game_started',
        data: {
          opponent: opponent,
          me: me,
          whos_turn: whos_turn
        }
      });
    };

    Protocol.prototype.boardChanged = function() {};

    Protocol.prototype.sendOk = function(id) {
      return this.send({
        method: 'ok',
        id: id
      });
    };

    Protocol.prototype.sendError = function(id, message) {
      return this.send({
        method: 'error',
        data: {
          message: message,
          code: 0
        },
        id: id
      });
    };

    Protocol.prototype.send = function(data) {
      var message;
      message = this.stringiffy(data);
      return this.conn.write(message);
    };

    return Protocol;

  })();

}).call(this);
