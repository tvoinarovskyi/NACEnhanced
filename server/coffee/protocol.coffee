### 
    Encapsulate protocol of socket data transmission
###

game = require('game')

class Protocol
    constructor: (@conn, @app) ->
        @conn.on('data', @onData)
        @conn.on('close', @close)
        @userID = @conn.remoteAddress + '_' + Math.random()
        @game = null

    onData: (message) ->
        data = @parse(message)
        switch data.method
            when 'connect'
                console.log('CONNECT')
                if !!app.pendingConnections
                    # Find pending connection and save it for comunication
                    @opponentConn = app.pendingConnections.pop()
                    opponentID = @opponentConn.userID
                    # Create game and notify players
                    @game = @createGame(@userID, opponentID)
                    @gameStarted(@userID, opponentID)
                    @opponentConn.gameStarted(opponentID, @userID)
                else
                    app.pendingConnections.push(@)
            when 'move'
                console.log('MOVE')
                if !@game 
                    return
                try
                    @game.move(@userID, data.data.board, data.data.field)
                catch error
                    if error instanceof game.MoveNotAllowed
                        @sendError(data.id, error.message)
                    else 
                        throw error
                    return
                @sendOk(data.id)
                @opponentConn.boardChanged()
            else
                # Just ignore broken ones
                null

    parse: (message) ->
        return JSON.parse(message)

    stringiffy: (data) ->
        return JSON.stringiffy(data)

    createGame: (me, opponent) ->
        newGame = new game.GameBoard(
            [me, opponent], 
            if Math.random()>0.5 then me else opponent
        )
        return newGame

    gameStarted: () ->
        if @game.players[0] == @userID
            opponentID = @game.players[1]
        else
            opponentID = @game.players[0]
        if @game.current_player == @userID
            whos_turn = 0
        else
            whos_turn = 1
        @send(
            method: 'game_started',
            data: 
                opponent: opponent,
                me: me,
                whos_turn: whos_turn
        )

    boardChanged: () ->
        null

    sendOk: (id) ->
        @send(
            method: 'ok'
            id: id
        )

    sendError: (id, message) ->
        @send(
            method: 'error'
            data:
                message: message
                code: 0
            id: id
        )

    send: (data) ->
        message = @stringiffy(data)
        @conn.write(message)
