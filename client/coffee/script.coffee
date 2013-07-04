window.serverUrl = 'http://localhost:3000/socks_api'
window.lastGame = 1
window.lastEvent = 1;

Game =
  id: 1
  divId: 'game'
  url: 'http://localhost:3000/'
  subfield: 0
  figure: 1
  playername: null
  pendingActions: null
  socket: null
  board: null
  
  create: () ->
    this.id = window.lastGame++
    this.pendingActions = []
    this.board = []
    for i in [0..8]
      array = []
      for j in [0..9]
        array.push 0
      this.board.push array 
    boardHtml = '<table class="game_board" cellspacing="0" cellpadding="0">'
    boardHtml += '<tbody>';
    for i in [0..2]
      rowHtml = '<tr>'
      for j in [0..2]
        rowHtml += '<td align="center">'
        rowHtml += '<table class="inner_board" cellspacing="0" cellpadding="0">'
        rowHtml += '<tbody>'
        for k in [0..2]
          rowHtml += '<tr>'
          for m in [0..2]
            id = 'game' + this.id + 'cell' + (i * 3 + j) * 9 + (k * 3 + m)
            rowHtml += '<td id="' + id + '" value=0 board="' + (i * 3 + j) + '" field="' +  (k * 3 + m) + '"class="innertd" align="center"></td>'
          rowHtml += '</tr>'
        rowHtml += '</tbody>'
        rowHtml += '</table>'
        rowHtml += '</td>'
      rowHtml += '</tr>'
      boardHtml += rowHtml
    boardHtml += '</tbody>';
    boardHtml += '</table>';
    that = this;
    $('#' + this.divId).html(boardHtml)
    $('#' + this.divId + ' > table').on('click', 'td.innertd', (e) ->
      board = $(this).attr 'board'
      field = $(this).attr 'field'
      that.move board, field
    )
    
  connect: (url) ->
    this.url = url
    this.socket = new SockJS(this.url)
    this.socket.onclose = this.connectionDropped
    
    this.socket.onmessage = (message) ->
      try
        message = JSON.parse message
      catch error
        return
      switch message.method
      
        when "game_start"
          # set opponent name
          if messsage.data.whoTurns is 0
            this.figure = 1
          else
            this.figure = 2
            this.waitForOponent()
            
        when "board_update"
          this.board = message.data.fullboard
          this.subfield = message.data.active
          this.updateBoard()
          
        when "game_end" then this.end message.data.winner
                
        when "update"
          this[message.data.field] = message.data.name
        
        when "disconnect"
          new Messi 'Opponent was disconnected. Restart the game?', 
            title: 'Opponent disconnected'
            buttons: [
              {id: 0
              label: 'Yes'
              val: 'Yes'}
              {id: 1
              label: 'No'
              val: 'No'}]
            callback: (answer) ->
              this.socket close 
              if answer is "Yes"
                this.create()
                this.connect serverUrl
        
        when "ok" then
        
        when "error" then
                
    console.log "connect finished"
    
  start: () ->
    alert "not implemented yet"
    
  connectionDropped: () ->
    new Messi 'Connection lost',
      title: 'Error'
      titleClass: 'anim error'
      buttons: [
       {id: 0
       label: 'Close'
       val: 'X'}]
    
  end: (winnerName) ->
    window.playedGames.push this.id
    winnerTitle = 'You have won!'
    if winnerName isnt this.playername then winnerTitle = "You've lost."
    new Messi 'The game is finished' + winnerTitle + '. Start new game?', 
      title: winnerTitle
      buttons: [
        {id: 0
        label: 'Yes'
        val: 'Yes'}
        {id: 1
        label: 'No'
        val: 'No'}]
      callback: (answer) ->
        this.socket close 
        if answer is "Yes"
          this.create()
          this.connect serverUrl
          
  move: (board, field) ->
    message = 
      method: "move"
      data: 
        board: board
        field: field
      id: window.lastEvent
    this.socket.send JSON.stringify message
    
    that = this
    callback = () ->
      that.board[board][field] = that.figure
      that.board[board][9] = that.board_winner(that.board[board])
      that.updateBoard()
      that.waitForOpponent()
    callback.call()
    this.pendingActions.push
      id: window.lastEvent
      callback: callback
    window.lastEvent++
    
  updateBoard: () ->
    for i in [0..8]
      for j in [0..8]
        if this.board[i][j] isnt 0
          id = 'game' + this.id + 'cell' + i * 9 + j
          imageUrl = ''
          if this.board[i][j] isnt parseInt $('#' + id).attr "value" 
            if this.board[i][j] is 1 then imageUrl = 'img/cross.png'
            if this.board[i][j] is 2 then imageUrl = 'img/knot.png'
            image = '<img width="40px" height="40px" src="' + imageUrl + '"></image>'
            $('#' + id).html image
            $('#' + id).attr("value", this.board[i][j])
      if this.board[i][9] isnt 0
        imageUrl = ''
        if this.board[i][9] is 1 then imageUrl = 'img/cross.png'
        if this.board[i][9] is 2 then imageUrl = 'img/knot.png'
        id = 'game' + this.id + 'cell' + i * 9 + 5
        $('#' + id).parents(".inner_board").css("background", "url(" + imageUrl + ") no-repeat center").css("background-size", "100% auto") 
  
  waitForOponent: () ->
  
  board_winner: (board) ->
    # Test if we have a full line in the board
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
            return board[test[0]]
    return 0

window.initGame = (divId) ->
  this.game = $.extend(true, {}, Game)
  this.game.divId = divId
  this.game.create()
  this.game.connect serverUrl
  
window.changeName = () ->
  alert "not implemented yet"
  
window.showRules = () ->
  new Messi 'testtesttest', {title: 'Rules', modal: true}
  
window.notificate = (text) ->
  new Notification "Tic-Tac-Toe", {body : text, icon : "http://memoriesofchocolate.files.wordpress.com/2010/09/knots-and-crosses-kavade.jpg"}
  
window.makeMove = (cell) ->
  image = '<img src="img/cross.png" width="40px" height="40px"></img>'
  $('#' + cell.id).html image
