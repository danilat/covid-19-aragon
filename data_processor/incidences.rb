class Incidences
  def initialize
    @places = {
      aragon:{
        "16/04/2020": 'De los casos nuevos 155 se corresponden con los resultados acumulados de los tests rápidos realizados en esa última semana. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "18/04/2020": 'La Dirección General de Salud Pública ha depurado los datos de altas, de modo que la cifra que se notifica este día es inferior al acumulado del día anterior. Fuente: <a href="http://aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1342/id.258983" target="_blank">Aragón Hoy</a>',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.',
        "30/04/2020": 'El aumento en el número de casos detectados se corresponde con la inclusión en la estadística de 166 casos confirmados procedentes del brote asociado a dos centros de trabajo de Binéfar y al aumento en el número de pruebas analizadas (un 82% más que en la jornada anterior). Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1341/id.259460" target="_blank">Aragón Hoy</a>.',
        "19/05/2020": 'Sanidad ha cambiado el criterio de contabilización de confirmados de forma que a partir del 18 solo se contabilizan como contagiados los confirmados a través de PCR y ELISA IgM. Este cambio de criterio provoca cifras no reales en las variaciones de casos activos, casos nuevos y altas.',
      },
      huesca: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.',
        "26/04/2020": 'En Huesca se ha corregido el dato del día anterior, el número de altas acumuladas a día 26/04 pasa de 226 a 211.',
        "30/04/2020": 'El aumento en el número de casos detectados se corresponde con la inclusión en la estadística de 166 casos confirmados procedentes del brote asociado a dos centros de trabajo de Binéfar. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1341/id.259460" target="_blank">Aragón Hoy</a>.',
        "05/05/2020": 'En Huesca se ha corregido el dato del día anterior, el número de fallecimientos acumuladas a día 05/05 pasa de 92 a 91.',
        "19/05/2020": 'Sanidad ha cambiado el criterio de contabilización de confirmados de forma que a partir del 18 solo se contabilizan como contagiados los confirmados a través de PCR y ELISA IgM. Este cambio de criterio provoca cifras no reales en las variaciones de casos activos, casos nuevos y altas.',
        "23/05/2020": 'En Huesca se ha corregido el dato de fallecimientos, el número de fsallecimientos acumulados a día 23/05 pasa de 102 a 99.',
        "29/05/2020": "En Huesca se ha corregido el dato de fallecimientos, el número de fallecimientos acumulados a día 29/05 pasa de 100 a 99.",
      },
      zaragoza: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.',
        "19/05/2020": 'Sanidad ha cambiado el criterio de contabilización de confirmados de forma que a partir del 18 solo se contabilizan como contagiados los confirmados a través de PCR y ELISA IgM. Este cambio de criterio provoca cifras no reales en las variaciones de casos activos, casos nuevos y altas.',
      },
      teruel: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "20/04/2020": 'En Teruel se ha corregido el dato del día anterior, el número de altas acumuladas a día 20/04 pasa de 118 a 117.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.',
        "19/05/2020": 'Sanidad ha cambiado el criterio de contabilización de confirmados de forma que a partir del 18 solo se contabilizan como contagiados los confirmados a través de PCR y ELISA IgM. Este cambio de criterio provoca cifras no reales en las variaciones de casos activos, casos nuevos y altas.',
        "23/05/2020": 'En Teruel se ha corregido el dato de nuevas altas, el número de altas acumuladas a día 23/05 pasa de 389 a 374.',
        "27/05/2020": "En Teruel se ha corregido el dato de fallecimientos, el número de fallecimientos acumulados a día 27/05 pasa de 86 a 85",
      },
      otros: {}
    }
  end

  def get(from, date)
    @places[from][date.to_sym]
  end
end
