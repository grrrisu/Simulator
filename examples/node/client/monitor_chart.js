"use strict";

module.exports = class TimeChart {

  constructor(options){
    this.chartElementId = options.chartElementId;
    this.palette        = options.palette;
    this.defaultSerie   = options.defaultSerie || 'default';
    this.yAxisElementId = options.yAxisElementId;
  }

  render(){

    let chartPalette = new Rickshaw.Color.Palette( { scheme: this.palette } );

    this.chart = new Rickshaw.Graph( {
      element: document.getElementById(this.chartElementId),
      width: 650,
      height: 200,
      renderer: 'bar',
      stroke: true,
      series: new Rickshaw.Series.FixedDuration([{ name: this.defaultSerie}], chartPalette, {
        timeInterval: 10000,
        maxDataPoints: 100,
        timeBase: new Date().getTime() / 1000
      })
    } );

    new Rickshaw.Graph.Axis.Y( {
      graph: this.chart,
      orientation: 'left',
      tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
      element: document.getElementById(this.yAxisElementId)
    } );

    new Rickshaw.Graph.HoverDetail({
      graph: this.chart,
      yFormatter: function(y){
        return Math.round(y);
      }
    });

    this.chart.render();

  }

  update(data){
    this.chart.series.addData(data);
    this.chart.render();
  }
}
