Game =
  id: 1
  divId: 'game'
  url: 'http://176.37.65.38/'
  websocketPort: 1337
  subfield: 0
  create: null
  connect: null
  start: null
  connectionDropped: null
  end: null
  move: null

window.initGame = (divId) ->
  game = $.extend(true, {}, Game)
  game.divId = divId
  $('#' + divId).html('test')
  