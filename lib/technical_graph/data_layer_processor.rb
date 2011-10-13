#encoding: utf-8

# Approximate data layer

class DataLayerProcessor
  STRATEGIES = {
    :rectangular => 'generate_vector_rectangular',
    :gauss => 'generate_vector_gauss'
  }
  DEFAULT_STRATEGY = :rectangular

  MIN_LEVEL = 1
  MAX_LEVEL = 200

  # use 'x' axis for processing also
  PROCESS_WITH_PARAMETER_DISTANCE = false

  # default Gauss coefficient
  DEFAULT_GAUSS_COEFF = 0.2

  def initialize(data_layer)
    @data_layer = data_layer
    @strategy = DEFAULT_STRATEGY
    @level = MIN_LEVEL
    @vector = Array.new
    @gauss_coeff = DEFAULT_GAUSS_COEFF

    @simple_smoother_x = false
  end

  attr_reader :vector
  attr_accessor :gauss_coeff

  # Level of approximation
  def level=(l)
    @level = l.to_i if l.to_i >= MIN_LEVEL and l.to_i < MAX_LEVEL
  end

  attr_reader :level

  # Choose other strategy from STRATEGIES
  def strategy=(s)
    method = STRATEGIES[s]
    @strategy = s unless method.nil?
  end

  attr_reader :strategy

  # smooth using X distance
  attr_accessor :simple_smoother_x

  # This vector will be used to process values (Y'es)
  # Use proper strategy
  def generate_vector
    method = STRATEGIES[@strategy]
    if method.nil?
      method = STRATEGIES[DEFAULT_STRATEGY]
    end
    return self.send(method)
  end

  # Process values
  def process
    t = Time.now
    old_data = @data_layer.data
    new_data = Array.new

    puts "X axis distance smoothing enabled" if simple_smoother_x

    (0...old_data.size).each do |i|
      new_data << DataPoint.xy(old_data[i].x, process_part(old_data, i))
    end

    puts "Smoothing completed, level #{level}, data size #{old_data.size}, time #{Time.now - t}"

    return new_data
  end

  # Process part (size depends on level)
  def process_part(old_data, position)
    # neutral data, used where position is near edge to calculate new value
    neutral_data = DataPoint.xy(old_data[position].x, old_data[position].y)
    part_array = Array.new(level, neutral_data)

    # add data from old_data to part_array
    offset = (level/2.0).floor
    # copying data
    (0...level).each do |l|
      copy_pos = position + l - offset
      # if copy_pos is inside data
      if copy_pos >= 0 and old_data.size > copy_pos
        part_array[l] = old_data[copy_pos]
      end
    end
    # here we should have part_array and vector
    # and now do some magic :]

    if simple_smoother_x == false
      return process_part_only_y(part_array)
    else
      return process_part_y_and_x(part_array)
    end

  end

  # Process part (size depends on level), only Y data
  def process_part_only_y(part_array)
    y_sum = 0.0
    (0...level).each do |l|
      y_sum += part_array[l].y * vector[l]
    end
    return y_sum
  end

  # Process part (size depends on level), Y and X data
  def process_part_y_and_x(part_array)
    y_sum = 0.0
    (0...level).each do |l|
      y_sum += part_array[l].y * vector[l]
    end
    return y_sum
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

    # calculation
    count = (level.to_f / 2.0).floor + 1

    v = Array.new
    # calculated
    (1..count).each do |i|
      v << Math::E ** ((-0.5) * (i*gauss_coeff) ** 2)
    end

    @vector = make_mirror(v, level)

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

# Make mirror array
# size = 7 => [ i[3], i[2], i[1], i[0], i[1], i[2], i[3] ]
# size = 8 => [ i[3], i[2], i[1], i[0], i[0], i[1], i[2], i[3] ]
  def make_mirror(input, size)
    a = Array.new(size, 0.1)
    if size.even?
      # two 'first' in central
      c_left = size/2 - 1
      c_right = size/2

      a[c_left] = input[0]
      a[c_right] = input[0]
    else
      # there is one 'first'
      c_left = (size/2.0).floor
      c_right = (size/2.0).floor

      a[c_left] = input[0]
      # a[c_right] = input[0]
    end

    # the rest
    i = 0
    while c_left > 0
      i += 1
      c_left -= 1
      c_right += 1

      a[c_left] = input[i]
      a[c_right] = input[i]
    end

    return a
  end

end