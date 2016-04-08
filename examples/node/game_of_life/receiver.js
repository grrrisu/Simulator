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

    socket.on('game_of_life.sim', (data) => {
      console.log("data received", data);
      let cell = data.answer;
      let element = $('.cell[data-coord="'+cell.x+':'+cell.y+'"]');
      if(cell.alive) {
        element.addClass('alive');
      } else {
        element.removeClass('alive');
      }
    });
  }

  renderMatrix(matrix, fields){
    fields.forEach((y) => {
      let row = document.createElement("div");
      $(row).addClass('clearfix');
      matrix.appendChild(row);
      y.forEach((cell) => {
        let alive_css = cell.alive ? ' alive' : '';
        $(row).append('<div class="cell'+alive_css+'" data-coord="'+cell.x+':'+cell.y+'"></div>');
      });
    });
  }

}
