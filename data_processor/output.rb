class DailyStatisticsOutput < Dry::Struct
  attribute :fecha, Types::Strict::String
  attribute :casos_confirmados, Types::Integer
  attribute :ingresos_hospitalarios, Types::Integer.default(0)
  attribute :ingresos_uci, Types::Integer.default(0)
  attribute :fallecimientos, Types::Integer
  attribute :casos_personal_sanitario, Types::Integer.default(0)
  attribute :altas, Types::Integer.default(0)
  attribute :confirmados_dia, Types::Integer
  attribute :total_personas, Types::Integer
  attribute :fallecimientos_dia, Types::Integer.optional
  attribute :altas_dia, Types::Integer
  attribute :ingresos_hospitalarios_dia, Types::Integer
  attribute :ingresos_uci_dia, Types::Integer
  attribute :casos_personal_sanitario_dia, Types::Integer
  attribute :diferencia_confirmados_activos, Types::Integer
  attribute :diferencia_confirmados_dia, Types::Integer
  attribute :diferencia_fallecimientos_dia, Types::Integer.optional
  attribute :diferencia_altas_dia, Types::Integer
  attribute :diferencia_ingresos_hospitalarios_dia, Types::Integer
  attribute :diferencia_ingresos_uci_dia, Types::Integer
  attribute :diferencia_casos_personal_sanitario_dia, Types::Integer
  attribute :incidencias, Types::Strict::String.optional

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

  def porcentaje_personas_confirmadas
    casos_confirmados.percent_of(total_personas)
  end

  def to_h
    hash = super.to_h
    hash[:confirmados_activos] = confirmados_activos
    hash[:porcentaje_ingresos_confirmados] = porcentaje_ingresos_confirmados
    hash[:porcentaje_uci_confirmados] = porcentaje_uci_confirmados
    hash[:porcentaje_fallecimiento_confirmados] = porcentaje_fallecimiento_confirmados
    hash[:porcentaje_sanitarios_confirmados] = porcentaje_sanitarios_confirmados
    hash[:porcentaje_altas_confirmados] = porcentaje_altas_confirmados
    hash[:porcentaje_personas_confirmadas] = porcentaje_personas_confirmadas
    hash
  end
end

class DailyOccupation < Dry::Struct
  attribute :date, Types::Strict::String
  attribute :total_beds, Types::Coercible::Integer
  attribute :total_beds_difference, Types::Coercible::Integer
  attribute :uci_beds, Types::Coercible::Integer
  attribute :uci_beds_difference, Types::Coercible::Integer

  def regular_beds
    total_beds - uci_beds
  end

  def to_h
    hash = super.to_h
    hash[:regular_beds] = regular_beds
    hash
  end

  def self.with_previous_daily_occupation(previous_daily_occupation, args)
    args[:total_beds_difference] = args[:total_beds]
    args[:uci_beds_difference] = args[:uci_beds]
    if previous_daily_occupation
      args[:total_beds_difference] = args[:total_beds] - previous_daily_occupation.total_beds
      args[:uci_beds_difference] = args[:uci_beds] - previous_daily_occupation.uci_beds
    end
    new(args)
  end
end

class Hospital < Dry::Struct
  attribute :name, Types::Strict::String
  attribute :daily_occupations, Types::Strict::Array.of(DailyOccupation)
end

class DailyOcupationAggregator < Dry::Struct
  def daily_occupations
    occupations_by_day.collect do |date, daily_occupations|
      total_beds = sum_occupations(daily_occupations, :total_beds)
      total_beds_difference = sum_occupations(daily_occupations, :total_beds_difference)
      uci_beds = sum_occupations(daily_occupations, :uci_beds)
      uci_beds_difference = sum_occupations(daily_occupations, :uci_beds_difference)
      DailyOccupation.new(date: date, total_beds: total_beds, total_beds_difference: total_beds_difference, uci_beds: uci_beds, uci_beds_difference: uci_beds_difference)
    end
  end

  def to_h
    hash = super.to_h
    hash[:daily_occupations] = daily_occupations.collect(&:to_h)
    hash
  end

  private def sum_occupations(daily_occupations, attribute)
    daily_occupations.inject(0){|sum, occupation| sum + occupation[attribute] }
  end

  def collection_with_daily_occupation
    raise "collection_with_daily_occupation is not implemented on #{self.class}"
  end

  private def occupations_by_day
    collection_with_daily_occupation.inject([]) do |sum, hospital|
      sum + hospital.daily_occupations
    end.group_by do |daily_occupation|
      daily_occupation[:date]
    end
  end
end

class Municipality < DailyOcupationAggregator
  attribute :name, Types::Strict::String
  attribute :hospitals, Types::Strict::Array.of(Hospital)

  private def collection_with_daily_occupation
    hospitals
  end
end

class Province < DailyOcupationAggregator
  attribute :name, Types::Strict::String
  attribute :municipalities, Types::Strict::Array.of(Municipality)

  private def collection_with_daily_occupation
    municipalities
  end
end

class HospitalOccupationOutput < DailyOcupationAggregator
  attribute :provinces, Types::Strict::Array.of(Province)

  private def collection_with_daily_occupation
    provinces
  end
end
