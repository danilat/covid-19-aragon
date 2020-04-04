---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: default
---
<script>
  var color = Chart.helpers.color;
  var config = {
    type: 'line',
    data: {
      labels: [
        {% for case in site.data.coronavirus_cases %}
          "{{ case.fecha }}",
        {% endfor%}
      ],
      datasets: [{
        label: 'Casos activos',
        backgroundColor: color("red").alpha(0.1).rgbString(),
        borderColor: "red",
        data: [
          {% for case in site.data.coronavirus_cases %}
            {{ case.confirmados_activos }},
          {% endfor%}
        ],
      },{
        label: 'Fallecimientos',
        backgroundColor: color("black").alpha(0.8).rgbString(),
        borderColor: "black",
        data: [
          {% for case in site.data.coronavirus_cases %}
            {{ case.fallecimientos_dia }},
          {% endfor%}
        ],
      },{
        label: 'Altas',
        backgroundColor: color("green").alpha(0.8).rgbString(),
        borderColor: "green",
        data: [
          {% for case in site.data.coronavirus_cases %}
            {{ case.altas_dia }},
          {% endfor%}
        ],
      }]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: 'Evolución del COVID-19 en Aragón'
      },
      tooltips: {
        mode: 'index',
        intersect: false,
      },
      hover: {
        mode: 'nearest',
        intersect: true
      },
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Fecha'
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
          labelString: 'Casos'
          }
        }]
      }
    }
  };

  window.onload = function() {
    var ctx = document.getElementById('canvas').getContext('2d');
    window.myLine = new Chart(ctx, config);
  };
</script>
<div style="width:100%;">
		<canvas id="canvas"></canvas>
</div>

{% assign last_day = site.data.coronavirus_cases | last %}
<h2>Últimos datos {{ last_day.fecha }}</h2>
<div>
  <ul>
    <li>Total de habitantes en Aragón <b>{{ last_day.total_personas}}</b>. Hay <b>{{ last_day.confirmados_activos}}</b> casos activos.</li>
    <li>Casos confirmados: <b>{{ last_day.casos_confirmados }}</b>. Un <b>{{ last_day.porcentaje_personas_confirmadas }} %</b> de aragoneses han sido casos confirmados.</li>
    <li>Ingresos hospitalarios: <b>{{ last_day.ingresos_hospitalarios }}</b>. Un <b>{{ last_day.porcentaje_ingresos_confirmados}} %</b> de los confirmados han requerido ingreso hospitalario.</li>
    <li>Ingresos en UCI: <b>{{ last_day.ingresos_uci }}</b>. Un <b>{{ last_day.porcentaje_uci_confirmados }} %</b> de los confirmados han sido ingresados en UCI.</li>
    <li>Fallecimientos: <b>{{ last_day.fallecimientos }}</b>, hoy <b>{{ last_day.fallecimientos_dia }}</b>. Un <b>{{ last_day.porcentaje_fallecimiento_confirmados }} %</b> de los confirmados han fallecido.</li>
    <li>Casos de personal sanitario: <b>{{ last_day.casos_personal_sanitario }}</b>. Un <b>{{ last_day.porcentaje_sanitarios_confirmados }} %</b> de los confirmados pertenecen a personal sanitario .</li>
    <li>Altas totales: <b>{{ last_day.altas }}</b>, hoy <b>{{last_day.altas_dia}}</b>.  Un <b>{{ last_day.porcentaje_altas_confirmados }} %</b> de casos confirmados se han dado de alta 💪.</li>
  </ul>
</div>


<span>Datos obtenidos de <a href="https://opendata.aragon.es/datos/catalogo/dataset/publicaciones-y-anuncios-relacionados-con-el-coronavirus-en-aragon">Aragón Open Data</a>, actualizados el {{ last_day.fecha }}.</span>

{% assign initial_day = site.data.coronavirus_cases | first %}
<h2>Progresión desde el {{ initial_day.fecha }}</h2>
<table>
  <tr>
    <th>fecha</th>
    <th>Casos activos</th>
    <th>Casos confirmados</th>
    <th>% confirmados</th>
    <th>Ingresos hospitalarios</th>
    <th>% ingresos</th>
    <th>Ingresos UCI</th>
    <th>% en UCI</th>
    <th>Fallecimientos día</th>
    <th>Fallecimientos</th>
    <th>% fallecimientos</th>
    <th>Personal sanitario</th>
    <th>% personal sanitario</th>
    <th>Alta día</th>
    <th>Altas</th>
    <th>% altas</th>
  </tr>
  {% for case in site.data.coronavirus_cases %}
  <tr>
    <td>{{ case.fecha }}</td>
    <td>{{ case.confirmados_activos }}</td>
    <td>{{ case.casos_confirmados }}</td>
    <td>{{ case.porcentaje_personas_confirmadas}} %</td>
    <td>{{ case.ingresos_hospitalarios }}</td>
    <td>{{ case.porcentaje_ingresos_confirmados}} %</td>
    <td>{{ case.ingresos_uci }}</td>
    <td>{{ case.porcentaje_uci_confirmados}} %</td>
    <td>{{ case.fallecimientos_dia }}</td>
    <td>{{ case.fallecimientos }}</td>
    <td>{{ case.porcentaje_fallecimiento_confirmados}} %</td>
    <td>{{ case.casos_personal_sanitario }}</td>
    <td>{{ case.porcentaje_sanitarios_confirmados}} %</td>
    <td>{{ case.altas_dia }}</td>
    <td>{{ case.altas }}</td>
    <td>{{ case.porcentaje_altas_confirmados}} %</td>
  </tr>
  {% endfor %}
</table>