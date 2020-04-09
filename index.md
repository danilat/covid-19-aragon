---
layout: default
---
<html lang="es">
  <head>
    <title>{{site.title}}</title>
    <meta name="description" content="{{site.description}}">
    <link rel="shortcut icon" href="https://www.danilat.com/img/favicon.png" type="image/x-icon">
    <link rel="stylesheet" href="https://www.danilat.com/css/main.css">
    <link rel="stylesheet" href="/assets/css/index.css">
    <style src="/assets/css/index.css"></style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.3/dist/Chart.min.js"></script>
    <script src="/assets/js/index.js"></script>
    <script>
      var fechas = [
        {% for case in site.data.coronavirus_cases %}"{{ case.fecha }}",{% endfor%}
      ]
      var casos_activos = [
        {% for case in site.data.coronavirus_cases %}{{ case.confirmados_activos }},{% endfor%}
      ]
      var fallecimientos_dia = [
        {% for case in site.data.coronavirus_cases %}{{ case.fallecimientos_dia }},{% endfor%}
      ]
      var altas_dia = [
        {% for case in site.data.coronavirus_cases %}{{ case.altas_dia }},{% endfor%}
      ]
      window.onload = function() {
        draw("chartAragon", getChartConfig({
          fechas: fechas, 
          casos_activos: casos_activos,
          fallecimientos_dia: fallecimientos_dia, 
          altas_dia: altas_dia})
        );
      }
    </script>
  </head>
  <body>
    <div class="container">
      <header class="header">
        <span>
          {{site.title}}
        </span>
      </header>
      <div class="content">
        <div class="chart-container">
            <canvas id="chartAragon"></canvas>
        </div>
        {% assign last_day = site.data.coronavirus_cases | last %}
        <h2>Últimos datos {{ last_day.fecha }}</h2>
        <div>
          <ul>
            <li>Casos confirmados: <b>{{ last_day.casos_confirmados }}</b>, hoy <b>{{ last_day.confirmados_activos}}</b>. Un <b>{{ last_day.porcentaje_personas_confirmadas }} %</b> de aragoneses han sido casos confirmados.</li>
            <li>Altas totales: <b>{{ last_day.altas }}</b>, hoy <b>{{last_day.altas_dia}}</b>.  Un <b>{{ last_day.porcentaje_altas_confirmados }} %</b> de casos confirmados se han dado de alta 💪.</li>
            <li>Fallecimientos: <b>{{ last_day.fallecimientos }}</b>, hoy <b>{{ last_day.fallecimientos_dia }}</b>. Un <b>{{ last_day.porcentaje_fallecimiento_confirmados }} %</b> de los confirmados han fallecido.</li>
            <li>Ingresos hospitalarios: <b>{{ last_day.ingresos_hospitalarios }}</b>. Un <b>{{ last_day.porcentaje_ingresos_confirmados}} %</b> de los confirmados han requerido ingreso hospitalario.</li>
            <li>Ingresos en UCI: <b>{{ last_day.ingresos_uci }}</b>. Un <b>{{ last_day.porcentaje_uci_confirmados }} %</b> de los confirmados han sido ingresados en UCI.</li>
            <li>Casos de personal sanitario: <b>{{ last_day.casos_personal_sanitario }}</b>. Un <b>{{ last_day.porcentaje_sanitarios_confirmados }} %</b> de los confirmados pertenecen a personal sanitario .</li> 
            <li>Total de habitantes en Aragón <b>{{ last_day.total_personas}}</b>. </li>
          </ul>
        </div>

        {% assign initial_day = site.data.coronavirus_cases | first %}
        <h2>Progresión desde el {{ initial_day.fecha }} en Aragón</h2>
        <table id ="aragon">
          <tr>
            <th>Fecha</th>
            <th>Casos activos diarios</th>
            <th>Casos activos totales</th>
            <th>Altas diarias</th>
            <th>Altas totales</th>
            <th>Fallecimientos diarios</th>
            <th>Fallecimientos totales</th>
          </tr>
          {% for case in site.data.coronavirus_cases %}
          <tr>
            <td>{{ case.fecha }}</td>
            <td>{{ case.confirmados_activos }}</td>
            <td>{{ case.casos_confirmados }}</td>
            <td>{{ case.altas_dia }}</td>
            <td>{{ case.altas }}</td>
            <td>{{ case.fallecimientos_dia }}</td>
            <td>{{ case.fallecimientos }}</td>
          </tr>
          {% endfor %}
        </table>

        {% assign initial_day = site.data.coronavirus_cases_huesca | first %}
        <h2>Progresión desde el {{ initial_day.fecha }} en Huesca</h2>
        <table id ="huesca">
          <tr>
            <th>Fecha</th>
            <th>Casos activos diarios</th>
            <th>Casos activos totales</th>
            <th>Altas diarias</th>
            <th>Altas totales</th>
            <th>Fallecimientos diarios</th>
            <th>Fallecimientos totales</th>
          </tr>
          {% for case in site.data.coronavirus_cases_huesca %}
          <tr>
            <td>{{ case.fecha }}</td>
            <td>{{ case.confirmados_activos }}</td>
            <td>{{ case.casos_confirmados }}</td>
            <td>{{ case.altas_dia }}</td>
            <td>{{ case.altas }}</td>
            <td>{{ case.fallecimientos_dia }}</td>
            <td>{{ case.fallecimientos }}</td>
          </tr>
          {% endfor %}
        </table>

        {% assign initial_day = site.data.coronavirus_cases_teruel | first %}
        <h2>Progresión desde el {{ initial_day.fecha }} en Teruel</h2>
        <table id ="teruel">
          <tr>
            <th>Fecha</th>
            <th>Casos activos diarios</th>
            <th>Casos activos totales</th>
            <th>Altas diarias</th>
            <th>Altas totales</th>
            <th>Fallecimientos diarios</th>
            <th>Fallecimientos totales</th>
          </tr>
          {% for case in site.data.coronavirus_cases_teruel %}
          <tr>
            <td>{{ case.fecha }}</td>
            <td>{{ case.confirmados_activos }}</td>
            <td>{{ case.casos_confirmados }}</td>
            <td>{{ case.altas_dia }}</td>
            <td>{{ case.altas }}</td>
            <td>{{ case.fallecimientos_dia }}</td>
            <td>{{ case.fallecimientos }}</td>
          </tr>
          {% endfor %}
        </table>

        {% assign initial_day = site.data.coronavirus_cases_zaragoza | first %}
        <h2>Progresión desde el {{ initial_day.fecha }} en Zaragoza</h2>
        <table id ="zaragoza">
          <tr>
            <th>Fecha</th>
            <th>Casos activos diarios</th>
            <th>Casos activos totales</th>
            <th>Altas diarias</th>
            <th>Altas totales</th>
            <th>Fallecimientos diarios</th>
            <th>Fallecimientos totales</th>
          </tr>
          {% for case in site.data.coronavirus_cases_zaragoza %}
          <tr>
            <td>{{ case.fecha }}</td>
            <td>{{ case.confirmados_activos }}</td>
            <td>{{ case.casos_confirmados }}</td>
            <td>{{ case.altas_dia }}</td>
            <td>{{ case.altas }}</td>
            <td>{{ case.fallecimientos_dia }}</td>
            <td>{{ case.fallecimientos }}</td>
          </tr>
          {% endfor %}
        </table>


        <span>Datos obtenidos de <a href="https://opendata.aragon.es/datos/catalogo/dataset/publicaciones-y-anuncios-relacionados-con-el-coronavirus-en-aragon">Aragón Open Data</a>, actualizados el {{ last_day.fecha }}.</span>
      </div>

      <div class="clearfix"></div>
      <footer class="site-footer">
              <span class="logo">
                <a href="https://www.danilat.com/">
                    <img src="https://www.danilat.com/img/logo-footer.png" alt="Logotipo de Danilat">
                  </a>
              </span>
      </footer>
    </div>
  </body>
</html>