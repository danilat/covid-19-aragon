class Incidences
  def initialize
    @places = {
      aragon:{
        "16/04/2020": 'De los casos nuevos 155 se corresponden con los resultados acumulados de los tests rápidos realizados en esa última semana. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "18/04/2020": 'La Dirección General de Salud Pública ha depurado los datos de altas, de modo que la cifra que se notifica este día es inferior al acumulado del día anterior. Fuente: <a href="http://aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1342/id.258983" target="_blank">Aragón Hoy</a>',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.'
      },
      huesca: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.'
      },
      zaragoza: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.'
      },
      teruel: {
        "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
        "20/04/2020": 'En Teruel se ha corregido el dato del día anterior, el número de altas acumuladas a día 20/04 pasa de 118 a 117.',
        "23/04/2020": 'Se ha modificado la cifra de las altas incluyendo también las altas epidemiológicas, es decir, las altas en casos confirmados que se han mantenido en su domicilio, que se suman a las hospitalarias. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/relmenu.9/id.259099" target="_blank">Aragón Hoy</a>.'
      },
      otros: {}
    }
  end

  def get(from, date)
    @places[from][date.to_sym]
  end
end