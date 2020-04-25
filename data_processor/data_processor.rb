require "dry-struct"
module Types
  include Dry.Types()
end
require "./data_processor/population"
require "./data_processor/downloader"
require "./data_processor/csv"
require "./data_processor/source_row"
require "./data_processor/target_row"
require "./data_processor/incidences"

class Numeric
  def percent_of(divisor)
    (self.to_f / divisor.to_f * 100.0).round(2)
  end
end

class ProcessToDailyProgression
  def initialize()
    @incidences = Incidences.new
  end

  def invoke(rows, place)
    source_rows = rows.collect do |row|
      data = row.to_h.transform_keys!(&:to_sym)
      SourceRow.new(data) if data[:casos_confirmados]
    end.compact
    target_rows = sources_to_targets(source_rows, place)
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
  
  def sources_to_targets(source_rows, from)
    previous_target_row = nil
    target_rows = source_rows.collect do |source_row|
      previous_target_row = source_to_target(source_row, from, previous_target_row)
    end
  end

  def source_to_target(source_row, from, previous_target_row)
    args = source_row.to_h
    args[:total_personas] = TOTAL_OF_PEOPLE[from] || 0
    date = Date.parse(args[:fecha])
    args[:fecha] = date.strftime("%d/%m/%Y")
    args[:incidencias] = @incidences.get(from, args[:fecha])
    populate_args_with_daily_and_diffs(args, previous_target_row)
    TargetRow.new(args)
  end
end