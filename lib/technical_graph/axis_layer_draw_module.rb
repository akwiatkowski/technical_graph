module AxisLayerDrawModule
  def x_axis_fixed?
     @options[:x_axises_fixed_interval] == true
   end

  # Value axis has fixed count
  def y_axis_fixed?
     @options[:y_axises_fixed_interval] == true
   end

  # Where to put axis values
  def value_axises
    return calc_axis(self.y_min, self.y_max, @options[:y_axises_interval], @options[:y_axises_count], y_axis_fixed?)
  end

  # Where to put axis values
  def parameter_axises
    return calc_axis(self.x_min, self.x_max, @options[:x_axises_interval], @options[:x_axises_count], x_axis_fixed?)
  end

  # Calculate axis using 2 methods
  def calc_axis(from, to, interval, count, fixed_interval)
    axises = Array.new
    l = to - from
    current = from
    
    if fixed_interval
      while current < to
        axises << current
        current += interval
      end
      return axises

    else
      (0...count).each do |i|
        axises << from + (l.to_f * i.to_f) / count.to_f
      end
      return axises

    end
  end

  # Render axis on image
  def render_on_image(image)
    @image = image
    # TODO
  end
end