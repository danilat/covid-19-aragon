require "./data_processor/data_processor"

# Aragón
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

download("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_aragon.csv", "_data/sources/casos_coronavirus_aragon.csv")
raw = read_csv("_data/sources/casos_coronavirus_aragon.csv")
process_daily_progression = ProcessToDailyProgression.new
target_rows = process_daily_progression.invoke(raw, :aragon)
write_csv(target_rows, "_data/coronavirus_cases.csv")
write_changelog(target_rows.last)

# Provinces
def ignore_first_rows(rows)
  rows.delete_at(1)
  rows.delete_at(0)
  rows
end

download("https://www.aragon.es/documents/20127/38742837/casos_coronavirus_provincias.csv", "_data/sources/casos_coronavirus_provincias.csv")
raw = read_csv("_data/sources/casos_coronavirus_provincias.csv")
by_province = {}
raw.group_by do |row|
  row["provincia"].downcase.to_sym
end.each do |province, rows|
  target_rows = process_daily_progression.invoke(rows, province.to_sym)
  ignore_first_rows(target_rows) #to avoid misinterpretations in the data because we don't have all the days evolution
  write_csv(target_rows, "_data/coronavirus_cases_#{province}.csv")
end
