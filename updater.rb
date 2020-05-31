require "./data_processor/data_processor"

def write_changelog(newer_coronavirus_row, newer_hospital_row)
  open("_data/last_update", "w") { |file|
    file.puts newer_coronavirus_row.fecha
  }
  changelog_message ="Actualización del #{ newer_coronavirus_row.fecha } en Aragón:
  - <b>#{ newer_coronavirus_row.confirmados_activos}</b> casos activos
  - <b>#{ newer_coronavirus_row.confirmados_dia}</b> casos nuevos
  - <b>#{ newer_coronavirus_row.altas_dia }</b> altas
  - <b>#{ newer_coronavirus_row.fallecimientos_dia }</b> fallecimientos
  - <b>#{ newer_hospital_row.regular_beds }</b> personas están ingresadas en planta 
  - <b>#{ newer_hospital_row.uci_beds }</b> personas están ingresadas en UCI
  <a href='http://www.curvaenaragon.com/'>Entra en CurvaEnAragón</a> para ver mas detalles."
  puts changelog_message
  open("_data/changelog_message", "w") { |file|
    file.puts changelog_message
  }
end

# Hospitals

download("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_hospitales.csv", "sources/casos_coronavirus_hospitales.csv")
raw = read_csv("sources/casos_coronavirus_hospitales.csv")
hospital_outputs = ProcessHospitalProgression.new.invoke(raw)
write_json(hospital_outputs, "_data/hospitals.json")

# Aragón

download("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_aragon.csv", "sources/casos_coronavirus_aragon.csv")
raw = read_csv("sources/casos_coronavirus_aragon.csv")
process_daily_progression = ProcessToDailyProgression.new
target_rows = process_daily_progression.invoke(raw, :aragon)
write_csv(target_rows, "_data/coronavirus_cases.csv")

write_changelog(target_rows.last, hospital_outputs.daily_occupations.last)

# Provinces
def ignore_first_rows(rows)
  rows.delete_at(1)
  rows.delete_at(0)
  rows
end

download("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_provincias.csv", "sources/casos_coronavirus_provincias.csv")
raw = read_csv("sources/casos_coronavirus_provincias.csv")
by_province = {}
raw.group_by do |row|
  row[:provincia].downcase.to_sym
end.each do |province, rows|
  target_rows = process_daily_progression.invoke(rows, province.to_sym)
  ignore_first_rows(target_rows) #to avoid misinterpretations in the data because we don't have all the days evolution
  write_csv(target_rows, "_data/coronavirus_cases_#{province}.csv")
end
