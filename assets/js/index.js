Chart.defaults.global.defaultFontFamily = "Lato, Open Sans";
function getChartConfigFor(args){
  var color = Chart.helpers.color;
  return config = {
    type: "line",
    data: {
      labels: args.dates,
      datasets: [{
        label: "  FALLECIMIENTOS",
        backgroundColor: color("#444444").alpha(0.9).rgbString(),
        borderColor: "#444444",
        data: args.deceases,
        pointBackgroundColor: "#444444",
      },{
        label: "  ALTAS",
        backgroundColor: color("#01afaf").alpha(0.6).rgbString(),
        borderColor: "#01afaf",
        data: args.recovered,
        pointBackgroundColor: "#01afaf",
      },{
        label: "  CASOS NUEVOS",
        backgroundColor: color("#f7849f").alpha(0.35).rgbString(),
        borderColor: "#f7849f",
        data: args.news,
        pointBackgroundColor: "#f7849f",
      },{
        label: "  CASOS ACTIVOS",
        backgroundColor: color("#919191").alpha(0.35).rgbString(),
        borderColor: "#919191",
        data: args.actives,
        pointBackgroundColor: "#919191",
      }]
    },
    options: {
      responsive: true,
      tooltips: {
        mode: "index",
        intersect: false,
        bodySpacing: 15,
        reverse: true,
        cornerRadius: 0,
        titleFontSize: 17,
        titleAlign: "center",
        titleMarginBottom: 15
      },
      legend: {
        reverse: true
      },
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: "FECHA",
            fontStyle: "bold",
            padding: {top: 30}
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: "PERSONAS",
            fontStyle: "bold",
            padding: {bottom: 30}
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
