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
  attribute :total_personas, Types::Coercible::Integer
  attribute :fallecimientos_dia, Types::Coercible::Integer
  attribute :altas_dia, Types::Coercible::Integer
  
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

def difference_by_day(source_row, previous_source_row, attribute)
  difference = source_row.send(attribute) - previous_source_row&.send(attribute) if previous_source_row
  difference = 0 unless difference&.positive?
  difference
end

def sources_to_targets(source_rows, from)
  previous_source_row = nil
  target_rows = source_rows.collect do |source_row|
    fallecimientos_dia = difference_by_day(source_row, previous_source_row, :fallecimientos)
    altas_dia = difference_by_day(source_row, previous_source_row, :altas)
    args = source_row.to_h.merge(total_personas: TOTAL_OF_PEOPLE[from], fallecimientos_dia: fallecimientos_dia, altas_dia: altas_dia)
    previous_source_row = source_row
    TargetRow.new(args)
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


