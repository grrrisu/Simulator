"use strict";

const retry = require('retry');

exports.connect = function(server, socket_file){

  const io = require('socket.io')(server);
  const unix_socket = require('./unix_socket');

  let player_id = null;

  io.on("connection", function(client){
    console.log("browser connected");
    let serverConnection = null;

    client.on("join", function(id, token){
      console.log(id + " : " + token + " joined");
      player_id = id;

      let operation = retry.operation();
      operation.attempt(function(currentAttempt){
        unix_socket.connect(socket_file, (err, socket) => {
          if(operation.retry(err)){
            client.emit("net-status", {message: "sim server is not available", error: err});
            return;
          } else {
            serverConnection = socket;
            serverConnection.browserConnection = client;
            client.emit("net-status", {message: "connected to sim server", error: null});
          }
        });

      });
    });

    client.on("action", function(data){
      console.log("message received ", data);
      if(serverConnection) {
        data.player_id = player_id;
        serverConnection.write(JSON.stringify(data)+"\r\n");
      } else {
        console.log("action dropped as we don't have any server connection");
      }
    });

    client.on("disconnect", function(data){
      console.log("client disconnected");
      if(serverConnection) {
        serverConnection.end();
      }
    });
  });

};
