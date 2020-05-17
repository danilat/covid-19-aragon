(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
Chart.defaults.global.defaultFontFamily = "Lato, Open Sans";
var color = Chart.helpers.color;

function evolutionChartData(args){
  return {
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
      label: "  NUEVOS",
      backgroundColor: color("#f7849f").alpha(0.4).rgbString(),
      borderColor: "#f7849f",
      data: args.news,
      pointBackgroundColor: "#f7849f",
    },{
      label: "  ACTIVOS",
      backgroundColor: color("#acb2b2").alpha(0.12).rgbString(),
      borderColor: "#acb2b2",
      data: args.actives,
      pointBackgroundColor: "#acb2b2",
    }]
  }
}

function hospitalCharData(args){
  return {
    labels: args.dates,
    datasets: [
      {
        label: " CAMAS EN PLANTA",
        backgroundColor: color("#acb2b2").alpha(0.8).rgbString(),
        borderColor: "#acb2b2",
        pointBackgroundColor: "#acb2b2",
        data: args.regularBeds
      },
      {
        label: " CAMAS EN UCI",
        backgroundColor: color("#f7849f").alpha(0.4).rgbString(),
        borderColor: "#f7849f",
        pointBackgroundColor: "#f7849f",
        data: args.uciBeds
      }
    ]
  };
}

function getTooltips(){
  return {
    mode: "index",
    intersect: false,
    bodySpacing: 15,
    reverse: true,
    cornerRadius: 0,
    titleFontSize: 17,
    titleAlign: "center",
    titleMarginBottom: 15
  }
}

function getLegends(){
  return {
    reverse: true,
    position: "top",
    labels: {
      fontSize: 15,
      padding: 40,
      usePointStyle: true,
      fontColor:"#08a4a4",
      filter: function(label) {
        if (!label.hidden){
          label.text += "   X"
        }else{
          label.text += "    "
        }
        return label
      }
    },
    onHover: function(e) {
      e.target.style.cursor = 'pointer';
    }
  }
}

function getChartHover(){
  return {
    onHover: function(e) {
      var point = this.getElementAtEvent(e);
      if (point.length) e.target.style.cursor = 'pointer';
      else e.target.style.cursor = 'default';
    }
  }
}

function getEvolutionChartConfigFor(args){
  if(!args) return;

  return {
    type: "line",
    data: evolutionChartData(args),
    options: {
      responsive: true,
      maintainAspectRatio: false,
      aspectRatio: 0.5,
      tooltips: getTooltips(),
      legend: getLegends(),
      hover: getChartHover(),
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: false,
            labelString: "FECHA",
            fontStyle: "bold",
            padding: {top: 20},
          }
        }],
        yAxes: [{
          display: true,
          ticks: {
            min:0
          },
          scaleLabel: {
            display: false,
            labelString: "PERSONAS",
            fontStyle: "bold",
            padding: {bottom: 20}
          }
        }]
      }
    }
  };
}

function getHospitalChartConfigFor(chartPlace){
  return {
    type: "line",
    data: hospitalCharData(chartPlace),
    options: {
      responsive: true,
      tooltips: getTooltips(),
      legend: getLegends(),
      hover: getChartHover(),
      scales: {
        xAxes: [{
          stacked: true,
          display: true,
          scaleLabel: {
            display: false,
            labelString: "FECHA",
            fontStyle: "bold",
            padding: {top: 20},
          }
        }],
        yAxes: [{
          stacked: true,
          display: true,
          ticks: {
            min:0
          },
          scaleLabel: {
            display: false,
            labelString: "PERSONAS INGRESADAS",
            fontStyle: "bold",
            padding: {bottom: 20}
          }
        }]
      }
    }
  }
}

function draw(canvasId, config){
  if (config == null) {
    console.log("Config for " + canvasId + " is null")
    return
  };
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

function stickMenu() {
  var header = document.getElementById("header");
  var sticky = header.offsetTop;

  if (window.pageYOffset > sticky) {
    header.classList.add("sticky");
  } else {
    header.classList.remove("sticky");
  }
}

function toggleIncidence(id){
  document.getElementById("incidence-" + id).classList.toggle("hide");
  document.getElementById("info-closed-" + id).classList.toggle("hide");
  document.getElementById("info-opened-" + id).classList.toggle("hide");
  document.getElementById("row-" + id).classList.toggle("opened");
}

function toggle(id){
  document.getElementById(id).classList.toggle("hide");
}

function ddmm(date) {
  var mm = date.getMonth() + 1;
  var dd = date.getDate();

  return [ 
          (dd>9 ? '' : '0') + dd,
          (mm>9 ? '' : '0') + mm,
        ].join('/');
};

function toChartPlace(place){
  var dailyOccupations = place.daily_occupations;
  var dates = []
  var regularBeds = []
  var uciBeds = []
  for (var index = 0; dailyOccupations.length > index; index++) {
   var date = new Date(dailyOccupations[index].date)
   dates.push(ddmm(date))
   regularBeds.push(dailyOccupations[index].regular_beds)
   uciBeds.push(dailyOccupations[index].uci_beds)
  }
  return {
    dates: dates,
    regularBeds: regularBeds,
    uciBeds: uciBeds
  }
}

var aragon;
var huesca;
var teruel;
var zaragoza;
window.onload = function() {
  if(Cookies.get('cookiesAllowed')){
    loadAnalytics();
  } else {
    document.getElementById("cookie-law").style.display = '';
    document.getElementById("accept-cookie-law").onclick = acceptCookies;
  }

  draw("chartAragon", getEvolutionChartConfigFor(aragon));
  draw("chartHuesca", getEvolutionChartConfigFor(huesca));
  draw("chartTeruel", getEvolutionChartConfigFor(teruel));
  draw("chartZaragoza", getEvolutionChartConfigFor(zaragoza));
}

window.onscroll = function (e) {
  if(!Cookies.get('cookiesAllowed')){
    var scrollTop = window.pageYOffset || (document.documentElement || document.body.parentNode || document.body).scrollTop
    if (scrollTop > 250){
      acceptCookies();
    }
  }
  stickMenu()
}
