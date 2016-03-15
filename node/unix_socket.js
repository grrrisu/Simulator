"use strict";

const net = require('net');

exports.connect = function(file, callback) {

  let client = net.connect({path: file});

  client.on("connect", function(){
    console.log("connected to server");
    callback(null, client);
  });

  client.on("error", function(err){
    console.log(err);
    callback(err, null);
  });

  client.on("data", function(data){
    console.log("data from server: ", data.toString());
    client.browserConnection.emit("action", data.toString());
  })

  client.on("end", function(){
    console.log("server disconnected");
    client.browserConnection.emit("net-status", {message: "sim server disconnected", error: null});
    client.browserConnection.serverConnection = null;
  });

};
