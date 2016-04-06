"use strict";

const express = require('express');
const app = express();
const server = require('http').createServer(app);

const web_socket  = require('./web_socket');
web_socket.connect(server, __dirname + '/../tmp/sockets/player.sock');

// add something here

server.listen(8080, function(){
  console.log("webserver listening on port 8080");
});
