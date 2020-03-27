require "net/http"
require "uri"
require "csv"

uri = URI.parse("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_aragon.csv")
response = Net::HTTP.get_response(uri)
content = response.body

total_aragoneses = 1319291 #https://opendata.aragon.es/apps/aragopedia/datos/#

csv = CSV.new(response.body, headers: true, col_sep: ";", liberal_parsing: true)
rows_to_add = csv.collect do |row|
  casos_confirmados = row["casos_confirmados"].to_f
  ingresos_hospitalarios = row["ingresos_hospitalarios"].to_f
  ingresos_uci = row["ingresos_uci"].to_f
  fallecimientos = row["fallecimientos"].to_f
  casos_personal_sanitario = row["casos_personal_sanitario"].to_f
  altas = row["altas"].to_f

  perc_aragoneses_confirmados = (casos_confirmados/total_aragoneses*100).round(2)
  perc_ingresos_confirmados = (ingresos_hospitalarios/casos_confirmados*100).round(2)
  perc_uci_confirmados = (ingresos_uci/casos_confirmados*100).round(2)
  perc_fallecimiento_confirmados = (fallecimientos/casos_confirmados*100).round(2)
  perc_sanitarios_confirmados = (casos_personal_sanitario/casos_confirmados*100).round(2)
  perc_altas_confirmados = (altas/casos_confirmados*100).round(2)

  confirmados_vigentes = (casos_confirmados - fallecimientos - altas).to_i

  row << ["perc_ingresos_confirmados", perc_ingresos_confirmados]
  row << ["perc_uci_confirmados", perc_uci_confirmados]
  row << ["perc_fallecimiento_confirmados", perc_fallecimiento_confirmados]
  row << ["perc_sanitarios_confirmados", perc_sanitarios_confirmados]
  row << ["perc_altas_confirmados", perc_altas_confirmados]
  row << ["total_aragoneses", total_aragoneses]
  row << ["perc_aragoneses_confirmados", perc_aragoneses_confirmados]
  row << ["confirmados_vigentes", confirmados_vigentes]
  row
end
headers = rows_to_add.first.headers
CSV.open("_data/coronavirus_cases.csv", "w", write_headers: true, headers: headers) do |cleaned_csv|
  rows_to_add.each do |row|
    cleaned_csv << row
  end
end
