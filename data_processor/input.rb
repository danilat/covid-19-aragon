class DailyStatisticsInput < Dry::Struct
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
  

  def to_h
    hash = super.to_h
    hash[:confirmados_activos] = confirmados_activos
    hash
  end
end