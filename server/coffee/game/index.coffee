### 
    Game logic. Mainly defines the board in which players will play
###

WIN = exports.WIN = "WIN"

class GameBoard
    constructor: (@players, @current_player) ->
        @board = (0 for j in [0..8] for i in [0..8])
        @main_board = (0 for i in [0..8])
        @current_board = 0

    dumpBoard: () ->
        res = ("=" for m in [0...25]).join('')+'\n'
        for i in [0..8]
            for j in [0..8]
                board = (Math.floor(i / 3)) * 3 + Math.floor(j / 3)
                field = (i % 3) * 3 + j % 3
                res += @board[board][field]
                if j == 2 || j == 5
                    res += " | "
                else 
                    res += " "
            if i == 2 || i == 5
                res += "\n"+("-" for m in [0...21]).join('')+"\n"
            else
                res += "\n"
        res += ("-" for m in [0...21]).join('')+'\n'
        for i in [0..2]
            for j in [0..2]
                field = i * 3 + j
                res += @main_board[field]
                res += " "
            res += "\n"
        res += ("=" for m in [0...25]).join('')+'\n'
        console.log(res)

    allowed_turn: () ->
        # Returns player and board allowed to play in
        return [@current_player, @current_board]

    board_playable: (board) -> 
        # Test if there is at least 1 playable spot in board
        if typeof board == 'number'
            board = @board[board]
        for bit in board
            if bit == 0
                return true
        return false

    board_finished: (board) ->
        # Test if we have a full line in the board
        if typeof board == 'number'
            board = @board[board]
        tests = [
            # Horizontal
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
            # Vertical
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            # Cross
            [0, 4, 8],
            [2, 4, 6]
        ]
        for test in tests
            all = (board[test[0]] != 0 &&
                   board[test[0]] == board[test[1]] && 
                   board[test[0]] == board[test[2]])
            if all
                return true
        return false


    move: (player, board, field) ->
        # Raises error if not allowed. Returns board state or WIN

        if (@players[0] == player)
            player_index = 1
        else
            player_index = 2

        if (player != @current_player)
            throw new MoveNotAllowed(
                "It is turn of player #{@current_player} not #{player}")
        if (@current_board != 0 && @current_board != board)
            throw new MoveNotAllowed(
                "You must use #{@current_board} board not #{board}")
        # Following logic will operate on indexes
        board -= 1
        field -= 1  
        if (@board[board][field] != 0)
            throw new MoveNotAllowed(
                "Field #{field} in board #{board} already set")

        @board[board][field] = player_index

        # If this board was not filled test if we have a full line
        if @main_board[board] == 0
            if @board_finished(board)
                @main_board[board] = player_index

        # Change player's turn
        player_index = if player_index == 1 then 2 else 1

        @current_player = @players[player_index-1]

        # Set next board to play
        if @board_playable(board)
            @current_board = field+1

        @dumpBoard()

        if @board_finished(@main_board)
            console.log("-----------------WIN------------------")
            return WIN

        return 

class MoveNotAllowed
    constructor: (@message) ->

    toString: () ->
        return @message

test = () ->
    # Create board
    gameBoard = new GameBoard(['user1', 'user2'], 'user1')
    # Make allowed move
    # gameBoard.move('user1', 1, 8)
    # gameBoard.move('user2', 8, 3)
    # gameBoard.move('user1', 3, 3)
    # gameBoard.move('user2', 3, 1)
    # gameBoard.move('user1', 1, 7)
    # gameBoard.move('user2', 7, 1)
    # gameBoard.move('user1', 1, 9)

    # gameBoard.move('user2', 9, 5)
    # gameBoard.move('user1', 5, 4)
    # gameBoard.move('user2', 4, 5)
    # gameBoard.move('user1', 5, 6)
    # gameBoard.move('user2', 6, 5)
    # gameBoard.move('user1', 5, 5)


    # gameBoard.move('user2', 5, 9)
    # gameBoard.move('user1', 9, 3)
    # gameBoard.move('user2', 3, 9)
    # gameBoard.move('user1', 9, 6)
    # gameBoard.move('user2', 6, 9)
    # gameBoard.move('user1', 9, 9)

    # Other board is not allowed 
    # gameBoard.move('user1', 5, 5)
    # gameBoard.move('user2', 9, 9)

    # User 2 turns are not allowed
    # gameBoard.move('user1', 5, 5)
    # gameBoard.move('user1', 5, 3)

    # Make not allowed move
    # gameBoard.move('user1', 1, 2)

test()
