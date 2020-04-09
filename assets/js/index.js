function getChartConfigFor(args){
  var color = Chart.helpers.color;
  return config = {
    type: "line",
    data: {
      labels: args.fechas,
      datasets: [{
        label: "Casos activos",
        backgroundColor: color("red").alpha(0.1).rgbString(),
        borderColor: "red",
        data: args.casosActivos,
      },{
        label: "Fallecimientos",
        backgroundColor: color("black").alpha(0.8).rgbString(),
        borderColor: "black",
        data: args.fallecimientosDia,
      },{
        label: "Altas",
        backgroundColor: color("green").alpha(0.8).rgbString(),
        borderColor: "green",
        data: args.altasDia,
      }]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: "Evolución del COVID-19 en Aragón"
      },
      tooltips: {
        mode: "index",
        intersect: false,
      },
      hover: {
        mode: "nearest",
        intersect: true
      },
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: "Fecha"
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
          labelString: "Casos activos"
          }
        }]
      }
    }
  };
}

function draw(canvasId, config){
  var ctx = document.getElementById(canvasId).getContext("2d");
  window[canvasId] = new Chart(ctx, config);
}