require "dry-struct"
module Types
  include Dry.Types()
end
require "./data_processor/population"
require "./data_processor/downloader"
require "./data_processor/csv"
require "./data_processor/input"
require "./data_processor/output"
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
    input_rows = rows.collect do |row|
      data = row.to_h.transform_keys!(&:to_sym)
      DailyStatisticsInput.new(data) if data[:casos_confirmados]
    end.compact
    inputs_to_outputs(input_rows, place)
  end

  def difference_by_day(args, previous_output, attribute)
    return args[attribute] unless previous_output
    args[attribute] - previous_output.send(attribute)
  end
  
  def populate_args_with_daily_and_diffs(args, previous_output)
    args[:diferencia_confirmados_activos] = difference_by_day(args, previous_output, :confirmados_activos)
    args[:confirmados_dia] = difference_by_day(args, previous_output, :casos_confirmados)
    args[:diferencia_confirmados_dia] = difference_by_day(args, previous_output, :confirmados_dia)
    args[:fallecimientos_dia] = difference_by_day(args, previous_output, :fallecimientos)
    args[:diferencia_fallecimientos_dia] = difference_by_day(args, previous_output, :fallecimientos_dia)
    args[:altas_dia] = difference_by_day(args, previous_output, :altas)
    args[:diferencia_altas_dia] = difference_by_day(args, previous_output, :altas_dia)
    args[:ingresos_hospitalarios_dia] = difference_by_day(args, previous_output, :ingresos_hospitalarios)
    args[:diferencia_ingresos_hospitalarios_dia] = difference_by_day(args, previous_output, :ingresos_hospitalarios_dia)
    args[:ingresos_uci_dia] = difference_by_day(args, previous_output, :ingresos_uci)
    args[:diferencia_ingresos_uci_dia] = difference_by_day(args, previous_output, :ingresos_uci_dia)
    args[:casos_personal_sanitario_dia] = difference_by_day(args, previous_output, :casos_personal_sanitario)
    args[:diferencia_casos_personal_sanitario_dia] = difference_by_day(args, previous_output, :casos_personal_sanitario_dia)
  end
  
  def inputs_to_outputs(inputs, from)
    previous_output = nil
    inputs.collect do |input_row|
      previous_output = input_to_output(input_row, from, previous_output)
    end
  end

  def input_to_output(input, from, previous_output)
    args = input.to_h
    args[:total_personas] = TOTAL_OF_PEOPLE[from] || 0
    date = Date.parse(args[:fecha])
    args[:fecha] = date.strftime("%d/%m/%Y")
    args[:incidencias] = @incidences.get(from, args[:fecha])
    populate_args_with_daily_and_diffs(args, previous_output)
    DailyStatisticsOutput.new(args)
  end
end

class ProcessHospitalProgression
  def invoke(rows)
    inputs = rows.collect do |row|
      data = row.to_h.transform_keys!(&:to_sym)
      HospitalOccupationInput.new(data)
    end.compact
    inputs_to_outputs(inputs)
  end

  def inputs_to_outputs(inputs)
    provinces = inputs.group_by do |input|
      input[:provincia]
    end.collect do |province, inputs|
      Province.new(name: province, municipalities: municipalities(inputs))
    end
    HospitalOccupationOutput.new(provinces: provinces)
  end

  private def municipalities(inputs)
    inputs.group_by do |input|
      input[:municipio]
    end.collect do |municipality, inputs|
      Municipality.new(name: municipality, hospitals: hospitals(inputs))
    end
  end

  private def hospitals(inputs)
    inputs.group_by do |input|
      input[:hospital]
    end.collect do |hospital, inputs|
      Hospital.new(name: hospital, daily_occupations: daily_occupations(inputs))
    end
  end

  private def daily_occupations(inputs)
    inputs.collect do |input|
      DailyOccupation.new(date: input[:fecha], total_beds: input[:camas_ocupadas_total], uci_beds: input[:camas_uci_ocupadas])
    end
  end
end