require "net/http"
require "uri"
require "csv"
require "dry-struct"

class Numeric
  def percent_of(divisor)
    (self.to_f / divisor.to_f * 100.0).round(2)
  end
end

module Types
  include Dry.Types()
end
class SourceRow < Dry::Struct
  transform_types do |type|
    if type.default?
      type.constructor do |value|
        value.nil? ? Dry::Types::Undefined : value
      end
    else
      type
    end
  end

  attribute :fecha, Types::Strict::String
  attribute :casos_confirmados, Types::Coercible::Integer
  attribute :ingresos_hospitalarios, Types::Coercible::Integer.default(0)
  attribute :ingresos_uci, Types::Coercible::Integer.default(0)
  attribute :fallecimientos, Types::Coercible::Integer.default(0)
  attribute :casos_personal_sanitario, Types::Coercible::Integer.default(0)
  attribute :altas, Types::Coercible::Integer.default(0)

  def confirmados_activos
    casos_confirmados - fallecimientos - altas
  end
  def porcentaje_ingresos_confirmados 
    ingresos_hospitalarios.percent_of(casos_confirmados)
  end
  def porcentaje_uci_confirmados 
    ingresos_uci.percent_of(casos_confirmados)
  end
  def porcentaje_fallecimiento_confirmados
    fallecimientos.percent_of(casos_confirmados)
  end
  def porcentaje_sanitarios_confirmados
    casos_personal_sanitario.percent_of(casos_confirmados)
  end
  def porcentaje_altas_confirmados
    altas.percent_of(casos_confirmados)
  end

  def to_h
    hash = super.to_h
    hash[:confirmados_activos] = confirmados_activos
    hash[:porcentaje_ingresos_confirmados] = porcentaje_ingresos_confirmados
    hash[:porcentaje_uci_confirmados] = porcentaje_uci_confirmados
    hash[:porcentaje_fallecimiento_confirmados] = porcentaje_fallecimiento_confirmados
    hash[:porcentaje_sanitarios_confirmados] = porcentaje_sanitarios_confirmados
    hash[:porcentaje_altas_confirmados] = porcentaje_altas_confirmados
    hash
  end
end

class TargetRow < SourceRow
  attribute :confirmados_dia, Types::Coercible::Integer
  attribute :total_personas, Types::Coercible::Integer
  attribute :fallecimientos_dia, Types::Coercible::Integer
  attribute :altas_dia, Types::Coercible::Integer
  attribute :ingresos_hospitalarios_dia, Types::Coercible::Integer
  attribute :ingresos_uci_dia, Types::Coercible::Integer
  attribute :casos_personal_sanitario_dia, Types::Coercible::Integer
  attribute :diferencia_confirmados_activos, Types::Coercible::Integer
  attribute :diferencia_confirmados_dia, Types::Coercible::Integer
  attribute :diferencia_fallecimientos_dia, Types::Coercible::Integer
  attribute :diferencia_altas_dia, Types::Coercible::Integer
  attribute :diferencia_ingresos_hospitalarios_dia, Types::Coercible::Integer
  attribute :diferencia_ingresos_uci_dia, Types::Coercible::Integer
  attribute :diferencia_casos_personal_sanitario_dia, Types::Coercible::Integer
  attribute :incidencias, Types::Strict::String.optional
  
  def porcentaje_personas_confirmadas
    casos_confirmados.percent_of(total_personas)
  end

  def to_h
    hash = super.to_h
    hash[:porcentaje_personas_confirmadas] = porcentaje_personas_confirmadas
    hash
  end
end

#https://opendata.aragon.es/apps/aragopedia/datos/#
TOTAL_OF_PEOPLE = {
  huesca: 220461,
  teruel: 134137,
  zaragoza: 964693,
  aragon: 1319291
}.freeze

def read_csv(uri)
  uri = URI.parse(uri)
  response = Net::HTTP.get_response(uri)
  content = response.body
  CSV.new(response.body, headers: true, col_sep: ";", liberal_parsing: true)
end

def difference_by_day(args, previous_target_row, attribute)
  return args[attribute] unless previous_target_row
  args[attribute] - previous_target_row.send(attribute)
end

def populate_args_with_daily_and_diffs(args, previous_target_row)
  args[:diferencia_confirmados_activos] = difference_by_day(args, previous_target_row, :confirmados_activos)
  args[:confirmados_dia] = difference_by_day(args, previous_target_row, :casos_confirmados)
  args[:diferencia_confirmados_dia] = difference_by_day(args, previous_target_row, :confirmados_dia)
  args[:fallecimientos_dia] = difference_by_day(args, previous_target_row, :fallecimientos)
  args[:diferencia_fallecimientos_dia] = difference_by_day(args, previous_target_row, :fallecimientos_dia)
  args[:altas_dia] = difference_by_day(args, previous_target_row, :altas)
  args[:diferencia_altas_dia] = difference_by_day(args, previous_target_row, :altas_dia)
  args[:ingresos_hospitalarios_dia] = difference_by_day(args, previous_target_row, :ingresos_hospitalarios)
  args[:diferencia_ingresos_hospitalarios_dia] = difference_by_day(args, previous_target_row, :ingresos_hospitalarios_dia)
  args[:ingresos_uci_dia] = difference_by_day(args, previous_target_row, :ingresos_uci)
  args[:diferencia_ingresos_uci_dia] = difference_by_day(args, previous_target_row, :ingresos_uci_dia)
  args[:casos_personal_sanitario_dia] = difference_by_day(args, previous_target_row, :casos_personal_sanitario)
  args[:diferencia_casos_personal_sanitario_dia] = difference_by_day(args, previous_target_row, :casos_personal_sanitario_dia)
end

def incidence_for(from, date)
  incidences = {
    aragon:{
      "16/04/2020": 'De los casos nuevos 155 se corresponden con los resultados acumulados de los tests rápidos realizados en esa última semana. Fuente: <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
      "18/04/2020": 'La Dirección General de Salud Pública ha depurado los datos de altas, de modo que la cifra que se notifica este día es inferior al acumulado del día anterior. Fuente: <a href="http://aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1342/id.258983" target="_blank">Aragón Hoy</a>'
    },
    huesca: {
      "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.'
    },
    zaragoza: {
      "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.'
    },
    teruel: {
      "18/04/2020": 'El descuadre a nivel provincial se debe a que este día se han añadido los casos confirmados por test rápidos que se contabilizaron en Aragón el día 16. Fuente:  <a href="http://www.aragonhoy.net/index.php/mod.noticias/mem.detalle/area.1050/id.258841" target="_blank">Aragón Hoy</a>.',
      "20/04/2020": 'En Teruel se ha corregido el dato del día anterior, el número de altas acumuladas a día 20/04 pasa de 118 a 117.'
    },
    otros: {}
  }
  incidences[from][date.to_sym]
end

def sources_to_targets(source_rows, from)
  previous_target_row = nil
  target_rows = source_rows.collect do |source_row|
    args = source_row.to_h
    args[:total_personas] = TOTAL_OF_PEOPLE[from] || 0
    date = Date.parse(args[:fecha])
    args[:fecha] = date.strftime("%d/%m/%Y")
    args[:incidencias] = incidence_for(from, args[:fecha])
    populate_args_with_daily_and_diffs(args, previous_target_row)
    target_row = TargetRow.new(args)
    previous_target_row = target_row
    target_row
  end
end

def write_csv(target_rows, path)
  headers = target_rows.first.to_h.keys
  CSV.open(path, "w", write_headers: true, headers: headers) do |targert_csv|
    target_rows.each do |target_row|
      targert_csv << target_row.to_h
    end
  end
end

def write_changelog(newer_row)
  open("_data/last_update", "w") { |file|
    file.puts newer_row.fecha
  }
  changelog_message ="Actualización del #{ newer_row.fecha } en Aragón:
  - <b>#{ newer_row.confirmados_activos}</b> casos activos
  - <b>#{ newer_row.confirmados_dia}</b> casos nuevos
  - <b>#{ newer_row.altas_dia }</b> altas
  - <b>#{ newer_row.fallecimientos_dia }</b> fallecimientos
  <a href='http://www.curvaenaragon.com/'>Entra en CurvaEnAragón</a> para ver mas detalles."
  puts changelog_message
  open("_data/changelog_message", "w") { |file|
    file.puts changelog_message
  }
end

csv = read_csv("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_aragon.csv")
source_rows = csv.collect do |row|
  data = row.to_h.transform_keys!(&:to_sym)
  SourceRow.new(data) if data[:casos_confirmados]
end.compact
target_rows = sources_to_targets(source_rows, :aragon)
write_csv(target_rows, "_data/coronavirus_cases.csv")
write_changelog(target_rows.last)

csv = read_csv("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_provincias.csv")
sources_by_province = {}
csv.group_by do |row|
  row["provincia"].downcase.to_sym
end.each do |province, rows|
  sources_by_province[province.to_sym] = rows.collect do |row|
    data = row.to_h.transform_keys!(&:to_sym)
    SourceRow.new(data)
  end
end

def ignore_first_row(rows)
  rows.delete_at(1)
  rows.delete_at(0)
  rows
end

sources_by_province.each do |province, source_rows|
  target_rows = sources_to_targets(source_rows, province)
  ignore_first_row(target_rows) #to avoid misinterpretations in the data because we don't have all the days evolution
  write_csv(target_rows, "_data/coronavirus_cases_#{province}.csv")
end


