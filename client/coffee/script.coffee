Game =
  id: 1
  divId: 'game'
  url: 'http://176.37.65.38/'
  websocketPort: 1337
  subfield: 0
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
      rowHtml += '<tr>'
      boardHtml += rowHtml
    boardHtml += '</tbody>';
    boardHtml += '</table>';
    $('#' + this.divId).html(boardHtml)
  connect: (url, port) ->
    alert "not implemented yet"
  start: () ->
    alert "not implemented yet"
  connectionDropped: () ->
    alert "not implemented yet"
  end: () ->
    alert "not implemented yet"
  move: () ->
    alert "not implemented yet"

window.initGame = (divId) ->
  game = $.extend(true, {}, Game)
  game.divId = divId
  game.create()
  