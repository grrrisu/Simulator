"use strict";

const SocketService = require('simulator-middleware/client/socket_service.js');
const MonitorController = require('./monitor_controller.js');

module.exports = class Game {

  constructor(){
    let socket = new SocketService().connect("http://localhost:8080", 123, 'abc-123');

    this.dispatch(socket);

    new MonitorController(socket);
  }

  dispatch(socket) {
    socket.on('example.*', function(data){
      console.log("data received", data);
      $('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('monitor.error', function(data){
      console.log("data received", data);
      let answer = data.answer;
      $('#errors').append('<div class="message">'+answer.component+': '+answer.error+' - '+answer.event+'</div>');
    });

    let emptyData = [{"label": 'empty', "values": [{"time": new Date().getTime(), y: 0}]}]
    let processedEventsChart = $('#processedEventsChart').epoch({
      type: 'time.bar',
      data: emptyData
    });

    socket.on('monitor.history', function(data){
      console.log("history", data);
      let chartData = [];
      let time = new Date().getTime();
      Object.keys(data.answer).forEach(function(key, index){
        let label = key.replace('::', ' ');
        chartData.push({"label": label, "time": time, "y": data.answer[key]});
      });
      console.log(chartData);
      if(chartData.length != 0){
        processedEventsChart.push(chartData);
      } else {
        processedEventsChart.push(emptyData);
      }
    });

    socket.on('monitor.snapshot', function(data){
      console.log("snapshot", data);
      //$('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('net-status', function(data){
      $('#status').html('<div class="message">'+data.message+'</div>');
    });
  }

}
