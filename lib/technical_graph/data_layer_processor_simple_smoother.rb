#encoding: utf-8

module DataLayerProcessorSimpleSmoother
  # Smoothing
  SIMPLE_SMOOTHER_STRATEGIES = {
    :rectangular => 'generate_vector_rectangular',
    :gauss => 'generate_vector_gauss'
  }
  DEFAULT_SIMPLE_SMOOTHER_STRATEGY = :rectangular

  MIN_SIMPLE_SMOOTHER_LEVEL = 1
  MAX_SIMPLE_SMOOTHER_LEVEL = 200

  # use 'x' axis for processing also
  PROCESS_WITH_PARAMETER_DISTANCE = false

  # default Gauss coefficient
  DEFAULT_GAUSS_COEFF = 0.2

  def simple_smoother_initialize
    @simple_smoother_strategy = DEFAULT_SIMPLE_SMOOTHER_STRATEGY
    @simple_smoother_level = MIN_SIMPLE_SMOOTHER_LEVEL
    @vector = Array.new
    @gauss_coeff = DEFAULT_GAUSS_COEFF

    @simple_smoother_x = false
  end

  attr_reader :vector
  attr_accessor :gauss_coeff

  # Simple_smoother_level of approximation
  def simple_smoother_level=(l)
    @simple_smoother_level = l.to_i if l.to_i >= MIN_SIMPLE_SMOOTHER_LEVEL and l.to_i < MAX_SIMPLE_SMOOTHER_LEVEL
  end

  attr_reader :simple_smoother_level

  # Choose other simple_smoother_strategy from SIMPLE_SMOOTHER_STRATEGIES
  def simple_smoother_strategy=(s)
    method = SIMPLE_SMOOTHER_STRATEGIES[s]
    @simple_smoother_strategy = s unless method.nil?
  end

  attr_reader :simple_smoother_strategy

  # smooth using X distance
  attr_accessor :simple_smoother_x

  # This vector will be used to process values (Y'es)
  # Use proper simple_smoother_strategy
  def generate_vector
    method = SIMPLE_SMOOTHER_STRATEGIES[@simple_smoother_strategy]
    if method.nil?
      method = SIMPLE_SMOOTHER_STRATEGIES[DEFAULT_SIMPLE_SMOOTHER_STRATEGY]
    end
    return self.send(method)
  end

  # Smooth values
  def simple_smoother_process
    # vector used for smoothing
    generate_vector

    t = Time.now
    old_data = @data
    new_data = Array.new

    # pre-processing, distance
    if simple_smoother_x == true
      puts "X axis distance smoothing enabled"

      (0...old_data.size).each do |i|
        new_data << DataPoint.xy(old_data[i].x, process_part(old_data, i, false))
      end

      old_data = new_data
      new_data = Array.new
    end

    puts "Y axis distance smoothing"

    (0...old_data.size).each do |i|
      new_data << DataPoint.xy(old_data[i].x, process_part(old_data, i))
    end

    puts "Smoothing completed, simple_smoother_level #{simple_smoother_level}, data size #{old_data.size}, time #{Time.now - t}"

    @data = new_data
    return new_data
  end

  # Process part (size depends on simple_smoother_level)
  def process_part(old_data, position, y_based = true)
    # neutral data, used where position is near edge to calculate new value
    neutral_data = DataPoint.xy(old_data[position].x, old_data[position].y)
    part_array = Array.new(simple_smoother_level, neutral_data)

    # add data from old_data to part_array
    offset = (simple_smoother_level/2.0).floor
    # copying data
    (0...simple_smoother_level).each do |l|
      copy_pos = position + l - offset
      # if copy_pos is inside data
      if copy_pos >= 0 and old_data.size > copy_pos
        part_array[l] = old_data[copy_pos]
      end
    end
    # here we should have part_array and vector
    # and now do some magic :]


    if y_based
      return process_part_only_y(part_array)
    else
      return process_part_only_x(part_array, neutral_data)
    end
  end

  # Process part (size depends on simple_smoother_level), only Y data
  def process_part_only_y(part_array, neutral_data = nil)
    y_sum = 0.0
    (0...simple_smoother_level).each do |l|
      y_sum += part_array[l].y * vector[l]
    end
    return y_sum
  end

  # Process part (size depends on simple_smoother_level), Y and X data
  def process_part_only_x(part_array, neutral_data)
    weights = Array.new
    w_sum = 0.0
    (0...simple_smoother_level).each do |l|
      p = part_array[l]
      x_distance = p.x_distance(neutral_data)
      w = (Math::E ** (-1.0 * 0.2 * x_distance)) + 1.0
      w_sum += w
      weights << w
    end

    w_prod = 0.0
    part_array.each_index { |i| w_prod += part_array[i].y * weights[i].to_f }
    return w_prod.to_f / w_sum.to_f
  end

  # This vector will be used to process values (Y'es), linear algorithm
  def generate_vector_rectangular
    @vector = Array.new
    # calculated
    (1..simple_smoother_level).each do |i|
      @vector << 1.0 / simple_smoother_level.to_f
    end
    return @vector
  end

  # This vector will be used to process values (Y'es), linear algorithm
  def generate_vector_gauss
    # http://www.techotopia.com/index.php/Ruby_Math_Functions_and_Methods#Ruby_Math_Constants
    # http://pl.wikipedia.org/wiki/Okno_czasowe

    # calculation
    count = (simple_smoother_level.to_f / 2.0).floor + 1

    v = Array.new
    # calculated
    (1..count).each do |i|
      v << Math::E ** ((-0.5) * (i*gauss_coeff) ** 2)
    end

    @vector = make_mirror(v, simple_smoother_level)

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