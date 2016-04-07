"use strict";

import $ from 'jquery';

module.exports = class Receiver {

  constructor(socket){
    this.socket = socket;
    this.listen(socket);
  }

  listen(socket){
    socket.on('game_of_life.build', (data) => {
      let matrix = document.getElementById("matrix");
      $(matrix).html('');
      this.renderMatrix(matrix, JSON.parse(data.answer));
    });

    socket.on('game_of_life.*', (data) => {
      console.log("data received", data);
      let time = new Date().toLocaleString();
      $('#messages').prepend('<tr class="message"><td>'+time+'</td><td>'+data.answer+'</td></tr>');
    });
  }

  renderMatrix(matrix, fields){
    fields.forEach((y) => {
      let row = document.createElement("div");
      $(row).addClass('clearfix');
      matrix.appendChild(row);
      y.forEach((x) => {
        let alive_css = x.alive ? ' alive' : '';
        $(row).append('<div class="cell'+alive_css+'"></div>');
      });
    });
  }

}
