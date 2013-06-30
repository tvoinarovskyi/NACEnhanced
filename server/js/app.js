/*
    Module dependencies.
*/


(function() {
  var app, express, http, http_server, path, routes, sockjs, socks_server, user;

  express = require('express');

  routes = require('./routes');

  user = require('./routes/test_socks');

  http = require('http');

  path = require('path');

  sockjs = require('sockjs');

  app = express();

  app.set('port', process.env.PORT || 3000);

  app.set('views', path.join(__dirname, '../views'));

  app.set('view engine', 'jade');

  app.use(express.favicon());

  app.use(express.logger('dev'));

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(express.cookieParser('njkdasd1l;2k3joidua093j2kl1'));

  app.use(express.session());

  app.use(app.router);

  app.use(express["static"](path.join(__dirname, '../public')));

  app.use('/client', express["static"](path.join(__dirname, '../../client')));

  if ('development' === app.get('env')) {
    app.use(express.errorHandler());
  }

  app.get('/', routes.index);

  app.get('/test_socks.html', user.list);

  socks_server = sockjs.createServer();

  socks_server.on('connection', function(conn) {
    conn.on('data', function(message) {
      message = JSON.parse(message);
      conn.write(message['title']);
    });
    return conn.on('close', function() {});
  });

  http_server = http.createServer(app);

  socks_server.installHandlers(http_server, {
    prefix: '/socks_api'
  });

  http_server.listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

}).call(this);
