(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
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
        backgroundColor: color("#f7849f").alpha(0.4).rgbString(),
        borderColor: "#f7849f",
        data: args.news,
        pointBackgroundColor: "#f7849f",
      },{
        label: "  CASOS ACTIVOS",
        backgroundColor: color("#acb2b2").alpha(0.12).rgbString(),
        borderColor: "#acb2b2",
        data: args.actives,
        pointBackgroundColor: "#acb2b2",
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
  console.log("loadingAnalytics") 
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-918753-15');
}

function acceptCookies(){
  loadAnalytics();
  document.getElementById("cookie-law").style.display = 'none';
  Cookies.set('cookiesAllowed', true);
}

window.onload = function() {
  if(Cookies.get('cookiesAllowed')){
    loadAnalytics();
  } else {
    document.getElementById("cookie-law").style.display = '';
    document.getElementById("accept-cookie-law").onclick = acceptCookies;
  }

  draw("chartAragon", getChartConfigFor(aragon));
  draw("chartHuesca", getChartConfigFor(huesca));
  draw("chartTeruel", getChartConfigFor(teruel));
  draw("chartZaragoza", getChartConfigFor(zaragoza));
}

window.onscroll = function (e) {  
  if(!Cookies.get('cookiesAllowed')){
    var scrollTop = window.pageYOffset || (document.documentElement || document.body.parentNode || document.body).scrollTop
    if (scrollTop > 250){
      acceptCookies();
    }
  }
}
