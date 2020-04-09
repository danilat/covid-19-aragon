Chart.defaults.global.defaultFontFamily = "Lato, Open Sans";
function getChartConfigFor(args){
  var color = Chart.helpers.color;
  return config = {
    type: "line",
    data: {
      labels: args.dates,
      datasets: [{
        label: "FALLECIMIENTOS",
        backgroundColor: color("#444444").alpha(0.9).rgbString(),
        borderColor: "#444444",
        data: args.deceases,
      },{
        label: "ALTAS",
        backgroundColor: color("#01afaf").alpha(0.6).rgbString(),
        borderColor: "#01afaf",
        data: args.recovered,
        },{
        label: "CASOS ACTIVOS",
        backgroundColor: color("#f7849f").alpha(0.35).rgbString(),
        borderColor: "#f7849f",
        data: args.actives,
        
      }]
    },
    options: {
      responsive: true,
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
            labelString: "FECHA"
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
          labelString: "CASOS ACTIVOS"
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

function loadAnalytics(){
  console.log("loadAnalytics is pending")
}

if(Cookies.get('cookiesAllowed')){
  loadAnalytics();
} else {
  document.getElementById("cookie-law").style.display = '';
  document.getElementById("accept-cookie-law").onclick = function(){
    loadAnalytics();
    Cookies.set('cookiesAllowed', true);
  }
}
