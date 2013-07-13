game = require('NACServer/game')

describe('Test the in-memory game board', ()->
    it('Test board for playable', ()->
        board = new game.GameBoard(['user1', 'user2'], 'user1')
        expect(board.board_playable(
            [ 1, 2, 1,
              1, 2, 1,
              2, 1, 2
            ]
        )).toBe(false)
        expect(board.board_playable(
            [ 1, 2, 1,
              1, 2, 1,
              2, 1, 0
            ]
        )).toBe(true)
        expect(board.board_playable(
            [ 0, 0, 0,
              0, 0, 0, 
              0, 0, 0
            ]
        )).toBe(true)
    )

    it('Test board for finished', ()->
        board = new game.GameBoard(['user1', 'user2'], 'user1')
        expect(board.board_finished(
            [ 0, 0, 0,
              0, 0, 0,
              0, 0, 0
            ]
        )).toBeFalsy()
        expect(board.board_finished(
            [ 1, 2, 2,
              2, 1, 1,
              2, 1, 2
            ]
        )).toBeFalsy()
        expect(board.board_finished(
            [ 1, 0, 0,
              2, 1, 0, 
              0, 2, 1
            ]
        )).toBe(1)
        expect(board.board_finished(
            [ 2, 0, 0,
              1, 1, 1, 
              0, 2, 2
            ]
        )).toBe(1)
        expect(board.board_finished(
            [ 2, 2, 2,
              1, 1, 2, 
              0, 1, 1
            ]
        )).toBe(2)
    )

    it('Enexpected calls to functions', ()->
        gameBoard = new game.GameBoard(['1', '2'], '2')
        # Out of range field
        expect(()->
            gameBoard.move('1', 8, 200)
        ).toThrow()
        # Out of range board
        expect(()->
            gameBoard.move('1', 800, 2)
        ).toThrow()
        # Lame user
        # Out of range field
        expect(()->
            gameBoard.move('111', 8, 2)
        ).toThrow()
    )


    it('Per turn state test', ()->
        gameBoard = new game.GameBoard(['1', '2'], '1')
        expect(gameBoard.allowed_turn()).toEqual(['1', 0])
        # Ok turn
        gameBoard.move('1', 1, 8)
        expect(gameBoard.allowed_turn()).toEqual(['2', 8])
        # Wrong user
        expect(()->
            gameBoard.move('1', 8, 2)
        ).toThrow()
        # Wrong board
        expect(()->
            gameBoard.move('2', 1, 2)
        ).toThrow()
        # Ok turn
        gameBoard.move('2', 8, 1)
        # Can not move on set field
        expect(()->
            gameBoard.move('1', 1, 8)
        ).toThrow()
    )

    it('Any allowed if board is full', ()->
        gameBoard = new game.GameBoard(['1', '2'], '1')
        # Set 1 board on full 
        gameBoard.move('1', 1, 2)
        gameBoard.move('2', 2, 1)
        gameBoard.move('1', 1, 3)
        gameBoard.move('2', 3, 1)
        gameBoard.move('1', 1, 4)
        gameBoard.move('2', 4, 1)
        gameBoard.move('1', 1, 5)
        gameBoard.move('2', 5, 1)
        gameBoard.move('1', 1, 6)
        gameBoard.move('2', 6, 1)
        gameBoard.move('1', 1, 7)
        gameBoard.move('2', 7, 1)
        gameBoard.move('1', 1, 8)
        gameBoard.move('2', 8, 1)
        gameBoard.move('1', 1, 9)
        gameBoard.move('2', 9, 1)
        gameBoard.move('1', 1, 1)
        expect(gameBoard.allowed_turn()).toEqual(['2', 0])
    )

    it("Full win test", () ->
        # Create board
        gameBoard = new game.GameBoard(['user1', 'user2'], 'user1')
        # Make allowed move
        gameBoard.move('user1', 1, 8)
        gameBoard.move('user2', 8, 3)
        gameBoard.move('user1', 3, 3)
        gameBoard.move('user2', 3, 1)
        gameBoard.move('user1', 1, 7)
        gameBoard.move('user2', 7, 1)
        gameBoard.move('user1', 1, 9)

        gameBoard.move('user2', 9, 5)
        gameBoard.move('user1', 5, 4)
        gameBoard.move('user2', 4, 5)
        gameBoard.move('user1', 5, 6)
        gameBoard.move('user2', 6, 5)
        res = gameBoard.move('user1', 5, 5)
        expect(res).toBeFalsy()

        gameBoard.move('user2', 5, 9)
        gameBoard.move('user1', 9, 3)
        gameBoard.move('user2', 3, 9)
        gameBoard.move('user1', 9, 6)
        gameBoard.move('user2', 6, 9)
        res = gameBoard.move('user1', 9, 9)
        expect(res).toBe(game.WIN)
        return
    )
)
