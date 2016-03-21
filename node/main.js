"use strict";

const app = require('express')();
const server = require('http').createServer(app);

const web_socket  = require('./web_socket');
web_socket.connect(server);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/public/reverse.html');
});
app.get('/crash', function(req, res){
  res.sendFile(__dirname + '/public/crash.html');
});
server.listen(8080, function(){
  console.log("webserver listening on port 8080");
});
