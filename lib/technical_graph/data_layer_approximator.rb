#encoding: utf-8

# Approximate data layer

class DataLayerApproximator
  STRATEGIES = {
    :rectangular => 'generate_vector_rectangular',
    :gauss => 'generate_vector_gauss'
  }
  DEFAULT_STRATEGY = :rectangular

  MIN_LEVEL = 1
  MAX_LEVEL = 10

  def initialize(data_layer)
    @data_layer = data_layer
    @strategy = DEFAULT_STRATEGY
    @level = MIN_LEVEL
    @vector = Array.new
  end

  attr_reader :vector

  # Level of approximation
  def level=(l)
    @level = l.to_i if l.to_i >= MIN_LEVEL and l.to_i < MAX_LEVEL
  end

  attr_reader :level

  # Choose other strategy from STRATEGIES
  def strategy=(s)
    puts s
    method = STRATEGIES[s]
    @strategy = s unless method.nil?
  end

  attr_reader :strategy


  # This vector will be used to process values (Y'es)
  # Use proper strategy
  def generate_vector
    method = STRATEGIES[@strategy]
    if method.nil?
      method = STRATEGIES[DEFAULT_STRATEGY]
    end
    return self.send(method)
  end

  # This vector will be used to process values (Y'es), linear algorithm
  def generate_vector_rectangular
    @vector = Array.new
    # calculated
    (1..level).each do |i|
      @vector << 1.0 / level.to_f
    end
    return @vector
  end

  # This vector will be used to process values (Y'es), linear algorithm
  def generate_vector_gauss
    # http://www.techotopia.com/index.php/Ruby_Math_Functions_and_Methods#Ruby_Math_Constants
    # http://pl.wikipedia.org/wiki/Okno_czasowe

    d = 0.4

    # calculation
    count = (level.to_f / 2.0).floor + 1

    v = Array.new
    # calculated
    (1..count).each do |i|
      v << Math::E ** ((-0.5) * (i*d) ** 2)
    end

    # TODO
    @vector = Array.new(level, 0.2)

    # 1 part

    puts v.inspect

    normalize_vector

    return @vector
  end

  # Multiply vector to have sum eq. 1.0
  def normalize_vector
    s = 0.0
    @vector.each do |v|
      s += v
    end

    new_vector = Array.new

    @vector.each do |v|
      new_vector << v / s
    end

    @vector = new_vector

    return @vector
  end

end