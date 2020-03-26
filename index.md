---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: default
---
<style>
table, th, td {
  border: 1px solid black;
}
</style>
<table>

  <tr>
    <th>fecha</th>
    <th>casos_confirmados</th>
    <th>ingresos_hospitalarios</th>
    <th>% ingresados</th>
    <th>ingresos_uci</th>
    <th>% en uci</th>
    <th>fallecimientos</th>
    <th>% fallecimientos</th>
    <th>casos_personal_sanitario</th>
    <th>% personal_sanitario</th>
    <th>altas</th>
    <th>% altas</th>
  </tr>
{% for case in site.data.coronavirus_cases %}
  <tr>
    <td>{{ case.fecha }}</td>
    <td>{{ case.casos_confirmados }}</td>
    <td>{{ case.ingresos_hospitalarios }}</td>
    <td>{{ case.perc_ingresos_confirmados }} %</td>
    <td>{{ case.ingresos_uci }}</td>
    <td>{{ case.perc_uci_confirmados }} %</td>
    <td>{{ case.fallecimientos }}</td>
    <td>{{ case.perc_fallecimiento_confirmados }} %</td>
    <td>{{ case.casos_personal_sanitario }}</td>
    <td>{{ case.perc_sanitarios_confirmados }} %</td>
    <td>{{ case.altas }}</td>
    <td>{{ case.perc_altas_confirmados }} %</td>
  </tr>
{% endfor %}
</table>