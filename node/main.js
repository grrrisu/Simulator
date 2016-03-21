"use strict";

const express = require('express');
const app = express();
const server = require('http').createServer(app);

const web_socket  = require('./web_socket');
web_socket.connect(server);

app.use(express.static('public'));

app.get('/', function(req, res){
  res.sendFile(__dirname + '/public/reverse.html');
});

server.listen(8080, function(){
  console.log("webserver listening on port 8080");
});
