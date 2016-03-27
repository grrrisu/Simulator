"use strict";

module.exports = function(){

  let errorsPalette = new Rickshaw.Color.Palette( { scheme: 'colorwheel' } );

  let errorsChart = new Rickshaw.Graph( {
    element: document.getElementById("errors-chart"),
    width: 650,
    height: 200,
    renderer: 'bar',
    stroke: true,
    series: new Rickshaw.Series.FixedDuration([{ name: 'errors'}], undefined, {
      color: errorsPalette.color(),
      timeInterval: 10000,
      maxDataPoints: 100,
      timeBase: new Date().getTime() / 1000
    })
  } );

  let errors_y_ticks = new Rickshaw.Graph.Axis.Y( {
    graph: errorsChart,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    element: document.getElementById('errors-y-axis')
  } );

  let errorsHoverDetail = new Rickshaw.Graph.HoverDetail({
    graph: errorsChart
  });

  errorsChart.render();

  return errorsChart;

}
