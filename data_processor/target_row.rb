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