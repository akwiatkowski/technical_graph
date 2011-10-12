#encoding: utf-8

# Approximate data layer

class DataLayerApproximator

  def initialize(data_layer)
    @data_layer = data_layer
    @level = 0
  end

  # Level of approximation
  def level=(l)
    @level = l.to_i if l.to_i >= 0 and l.to_i < 10
  end
  attr_reader :level

  # This vector will be used to process values (Y'es)
  def generate_vector
    return []
  end

end