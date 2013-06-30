Game =
  id: 1
  divId: 'game'
  url: 'http://176.37.65.38/'
  subfield: 0
  socket: null
  create: () ->
    boardHtml = '<table class="game_board" cellspacing="0" cellpadding="0">'
    boardHtml += '<tbody>';
    for i in [1..3]
      rowHtml = '<tr>'
      for j in [1..3]
        rowHtml += '<td align="center">'
        rowHtml += '<table class="inner_board" cellspacing="0" cellpadding="0">'
        rowHtml += '<tbody>'
        for k in [1..3]
          rowHtml += '<tr>'
          for m in [1..3]
            rowHtml += '<td align="center"></td>'
          rowHtml += '</tr>'
        rowHtml += '</tbody>'
        rowHtml += '</table>'
        rowHtml += '</td>'
      rowHtml += '</tr>'
      boardHtml += rowHtml
    boardHtml += '</tbody>';
    boardHtml += '</table>';
    $('#' + this.divId).html(boardHtml)
  connect: (url) ->
    this.url = url
    this.socket = new SockJS(this.url)
    this.socket.onopen = () ->
      console.log "socket opened"
    this.socket.onclose = () ->
      console.log "socket closed"
    this.socket.onmessage = (message) ->
      handleMessage message
  start: () ->
    alert "not implemented yet"
  connectionDropped: () ->
    alert "not implemented yet"
  end: () ->
    alert "not implemented yet"
  move: () ->
    alert "not implemented yet"

handleMessage = (message) ->
  console.log "message"

window.initGame = (divId) ->
  this.game = $.extend(true, {}, Game)
  this.game.divId = divId
  this.game.create()
  this.game.connect("http://localhost:3000/socks_api")
  
window.changeName = () ->
  alert "not implemented yet"
  
window.showRules = () ->
  new Messi 'testtesttest', {title: 'Rules', modal: true}
  
window.notificate = (text) ->
  new Notification "Tic-Tac-Toe", {body : text, icon : "http://memoriesofchocolate.files.wordpress.com/2010/09/knots-and-crosses-kavade.jpg"}
  