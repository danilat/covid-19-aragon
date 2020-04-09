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
  attribute :diferencia_confirmados_activos, Types::Coercible::Integer
  attribute :diferencia_confirmados_dia, Types::Coercible::Integer
  attribute :diferencia_fallecimientos_dia, Types::Coercible::Integer
  attribute :diferencia_altas_dia, Types::Coercible::Integer
  
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

def sources_to_targets(source_rows, from)
  previous_target_row = nil
  target_rows = source_rows.collect do |source_row|
    args = source_row.to_h
    args[:total_personas] = TOTAL_OF_PEOPLE[from] || 0
    args[:diferencia_confirmados_activos] = difference_by_day(args, previous_target_row, :confirmados_activos)
    args[:confirmados_dia] = difference_by_day(args, previous_target_row, :casos_confirmados)
    args[:diferencia_confirmados_dia] = difference_by_day(args, previous_target_row, :confirmados_dia)
    args[:fallecimientos_dia] = difference_by_day(args, previous_target_row, :fallecimientos)
    args[:diferencia_fallecimientos_dia] = difference_by_day(args, previous_target_row, :fallecimientos_dia)
    args[:altas_dia] = difference_by_day(args, previous_target_row, :altas)
    args[:diferencia_altas_dia] = difference_by_day(args, previous_target_row, :altas_dia)
    args[:fecha] = Date.parse(args[:fecha]).strftime("%d/%m/%Y")
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

csv = read_csv("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_aragon.csv")
source_rows = csv.collect do |row|
  data = row.to_h.transform_keys!(&:to_sym)
  SourceRow.new(data) if data[:casos_confirmados]
end.compact
target_rows = sources_to_targets(source_rows, :aragon)
write_csv(target_rows, "_data/coronavirus_cases.csv")

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

sources_by_province.each do |province, source_rows|
  target_rows = sources_to_targets(source_rows, province)
  write_csv(target_rows, "_data/coronavirus_cases_#{province}.csv")
end


