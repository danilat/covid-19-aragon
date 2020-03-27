---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: default
---
{% assign last_day = site.data.coronavirus_cases | first %}
<h2>Últimos datos {{ last_day.fecha }}</h2>
<div>
  <ul>
    <li>Total de habitantes en Aragón <b>{{ last_day.total_aragoneses}}</b>.</li>
    <li>Casos confirmados: <b>{{ last_day.casos_confirmados }}</b>. Un <b>{{ last_day.perc_aragoneses_confirmados }} %</b> de aragoneses han sido casos confirmados.</li>
    <li>Ingresos hospitalarios: <b>{{ last_day.ingresos_hospitalarios }}</b>. Un <b>{{ last_day.perc_ingresos_confirmados}} %</b> de los confirmados han requerido ingreso hospitalario.</li>
    <li>Ingresos en UCI: <b>{{ last_day.ingresos_uci }}</b>. Un <b>{{ last_day.perc_uci_confirmados }} %</b> de los confirmados han sido ingresados en UCI.</li>
    <li>Fallecimientos: <b>{{ last_day.fallecimientos }}</b>. Un <b>{{ last_day.perc_fallecimiento_confirmados }} %</b> de los confirmados han fallecido.</li>
    <li>Casos de personal sanitario: <b>{{ last_day.casos_personal_sanitario }}</b>. Un <b>{{ last_day.perc_altas_confirmados }} %</b> de los confirmados pertenecen a personal sanitario .</li>
    <li>Altas totales: <b>{{ last_day.altas }}</b>. Un <b>{{ last_day.perc_altas_confirmados }} %</b> de casos confirmados se han dado de alta 💪.</li>
  </ul>
</div>


<span>Datos obtenidos de <a href="https://opendata.aragon.es/datos/catalogo/dataset/publicaciones-y-anuncios-relacionados-con-el-coronavirus-en-aragon">Aragón Open Data</a>, actualizados el {{ last_day.fecha }}.</span>

{% assign initial_day = site.data.coronavirus_cases | last %}
<h2>Progresión desde el {{ initial_day.fecha }}:</h2>
<table>
  <tr>
    <th>fecha</th>
    <th>Casos confirmados</th>
    <th>% confirmados</th>
    <th>Ingresos hospitalarios</th>
    <th>% ingresos</th>
    <th>Ingresos UCI</th>
    <th>% en UCI</th>
    <th>Fallecimientos</th>
    <th>% fallecimientos</th>
    <th>Personal sanitario</th>
    <th>% personal sanitario</th>
    <th>Altas</th>
    <th>% altas</th>
  </tr>
  {% for case in site.data.coronavirus_cases %}
  <tr>
    <td>{{ case.fecha }}</td>
    <td>{{ case.casos_confirmados }}</td>
    <td>{{ case.perc_aragoneses_confirmados}} %</td>
    <td>{{ case.ingresos_hospitalarios }}</td>
    <td>{{ case.perc_ingresos_confirmados}} %</td>
    <td>{{ case.ingresos_uci }}</td>
    <td>{{ case.perc_uci_confirmados}} %</td>
    <td>{{ case.fallecimientos }}</td>
    <td>{{ case.perc_fallecimiento_confirmados}} %</td>
    <td>{{ case.casos_personal_sanitario }}</td>
    <td>{{ case.perc_sanitarios_confirmados}} %</td>
    <td>{{ case.altas }}</td>
    <td>{{ case.perc_altas_confirmados}} %</td>
  </tr>
  {% endfor %}
</table>