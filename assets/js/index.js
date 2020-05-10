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
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      aspectRatio: 0.5,
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
      },
      hover: {
        onHover: function(e) {
          var point = this.getElementAtEvent(e);
          if (point.length) e.target.style.cursor = 'pointer';
          else e.target.style.cursor = 'default';
        }
      },
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
            stepSize:1000,
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
  if (aragon){
    draw("chartAragon", getChartConfigFor(aragon));
    draw("chartHuesca", getChartConfigFor(huesca));
    draw("chartTeruel", getChartConfigFor(teruel));
    draw("chartZaragoza", getChartConfigFor(zaragoza));
  }
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
