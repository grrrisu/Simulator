"use strict";

const express = require('express');
const app = express();
const server = require('http').createServer(app);

const web_socket  = require('simulator-middleware/lib/web_socket');
web_socket.connect(server, __dirname + '/../../tmp/sockets/player.sock');

app.use(express.static('public'));
app.use(express.static('node_modules/bootstrap/dist'));
app.use(express.static('node_modules/rickshaw'));

// read port from ENV (eg. Heroku)
let port = process.env.PORT || 8080;

server.listen(port, function(){
  console.log('webserver listening on port ' + port);
});
