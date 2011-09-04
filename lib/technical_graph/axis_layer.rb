#encoding: utf-8

# Decide min/max values and draw axises

class AxisLayer

  def initialize(options = { })
    @options = options
    @options[:x_min] ||= (Time.now - 24 * 3600).to_f
    @options[:x_max] ||= Time.now.to_f
    @options[:y_min] ||= 0.0
    @options[:y_max] ||= 1.0
    # :default - coords are default
    # :fixed or whatever else - min/max coords are fixed
    @options[:xy_behaviour] ||= :default
  end

  # Ranges are fixed
  def fixed?
    @options[:xy_behaviour] == :fixed
  end

  def x_min
    @options[:x_min]
  end

  def x_max
    @options[:x_max]
  end

  def y_min
    @options[:y_min]
  end

  def y_max
    @options[:y_max]
  end

  private
  def x_min=(x)
    @options[:x_min] = x
  end

  def x_max=(x)
    @options[:x_max] = x
  end

  def y_min=(y)
    @options[:y_min] = y
  end

  def y_max=(y)
    @options[:y_max] = y
  end

  public

  # Consider changing ranges
  def process_data_layer(data_layer)
    # ranges are set, can't change sir
    return if fixed?

    # updating ranges
    self.y_max = data_layer.y_max if not data_layer.y_max.nil? and data_layer.y_max > y_max
    self.x_max = data_layer.x_max if not data_layer.x_max.nil? and data_layer.x_max > x_max

    self.y_min = data_layer.y_min if not data_layer.y_min.nil? and data_layer.y_min < y_min
    self.x_min = data_layer.x_min if not data_layer.x_min.nil? and data_layer.x_min < x_min
  end

end