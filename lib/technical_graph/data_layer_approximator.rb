#encoding: utf-8

# Approximate data layer

class DataLayerApproximator

  def initialize(data_layer)
    @data_layer = data_layer
    @level = 1
  end

  # Level of approximation
  def level=(l)
    @level = l.to_i if l.to_i >= 1 and l.to_i < 10
  end

  attr_reader :level

  # This vector will be used to process values (Y'es)
  def generate_vector
    v = Array.new
    # calculated
    (1..level).each do |i|
      v << 1.0 / level.to_f
    end
    return v
  end

end