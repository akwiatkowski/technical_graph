#encoding: utf-8

# Calculate axis (only) and draw them

class GraphAxis

  attr_reader :technical_graph

  # Accessor for options Hash
  def options
    @technical_graph.options
  end

  # Accessor for DataLayer Array
  def layers
    @technical_graph.layers
  end

  # Calculate everything
  def data_processor
    @technical_graph.data_processor
  end

  def image
    @technical_graph.image_drawer
  end

  def drawer
    image.drawer
  end

  def logger
    @technical_graph.logger
  end

  def truncate_string
    options[:truncate_string]
  end

  def initialize(technical_graph)
    @technical_graph = technical_graph
  end

  def x_axis_fixed?
    options[:x_axis_fixed_interval] == true
  end

  # Value axis has fixed count
  def y_axis_fixed?
    options[:y_axis_fixed_interval] == true
  end

  def y_axis_interval
    options[:y_axis_interval]
  end

  def x_axis_interval
    options[:x_axis_interval]
  end

  # Where to put axis values
  def value_axis
    return calc_axis(data_processor.y_min, data_processor.y_max, options[:y_axis_interval], options[:y_axis_count], y_axis_fixed?)
  end

  # Where to put axis values
  def parameter_axis
    return calc_axis(data_processor.x_min, data_processor.x_max, options[:x_axis_interval], options[:x_axis_count], x_axis_fixed?)
  end

  # Calculate axis using 2 methods
  def calc_axis(from, to, interval, count, fixed_interval)
    t = Time.now

    axis = Array.new
    l = to - from
    current = from

    if fixed_interval
      while current < to
        axis << current
        current += interval
      end
      logger.debug "fixed interval axis calculation from #{from} to #{to} using int. #{interval}"
      logger.debug " TIME COST #{Time.now - t}"
      return axis

    else
      (0...count).each do |i|
        axis << from + (l.to_f * i.to_f) / count.to_f
      end
      logger.debug "fixed count axis calculation from #{from} to #{to} using count #{count}"
      logger.debug " TIME COST #{Time.now - t}"
      return axis

    end
  end

  # Enlarge image to maintain proper axis density
  def axis_distance_image_enlarge
    if options[:axis_density_enlarge_image]
      t = Time.now
      x_axis_distance_image_enlarge
      y_axis_distance_image_enlarge

      logger.debug "axis enlarged"
      logger.debug " TIME COST #{Time.now - t}"
    end
  end

  # Enlarge image to maintain proper axis density
  def x_axis_distance_image_enlarge
    a = parameter_axis
    # must be at least 2 axis
    return if a.size < 2

    ax = a[0]
    ax = image.calc_bitmap_y(ax).round
    bx = a[1]
    bx = image.calc_bitmap_y(bx).round

    axis_distance = (bx - ax).abs

    if axis_distance < options[:x_axis_min_distance]
      # enlarging image
      options[:old_width] = options[:width]
      options[:width] *= (options[:x_axis_min_distance] / axis_distance).ceil
    end
  end

  # Enlarge image to maintain proper axis density
  def y_axis_distance_image_enlarge
    a = value_axis
    # must be at least 2 axis
    return if a.size < 2

    ay = a[0]
    ay = image.calc_bitmap_y(ay).round
    by = a[1]
    by = image.calc_bitmap_y(by).round

    axis_distance = (by - ay).abs

    if axis_distance < options[:y_axis_min_distance]
      # enlarging image
      options[:old_height] = options[:height]
      options[:height] *= (options[:y_axis_min_distance] / axis_distance).ceil
    end
  end

  # Render axis on image
  def render_on_image(image)
    @image = image

    render_axis
    render_zero_axis
    render_axis_labels
  end

  def antialias
    options[:antialias] == true
  end

  # Render normal axis
  def render_axis
    drawer.axis(
      # X
      parameter_axis.collect { |x| image.calc_bitmap_x(x).to_i },
      # Y
      value_axis.collect { |y| image.calc_bitmap_y(y).to_i },
      # options
      { :color => options[:axis_color], :width => 1 },
      # draw labels
      options[:axis_value_and_param_labels],
      # X axis labels
      parameter_axis,
      # Y axis labels
      value_axis
    )
  end

  # Render axis for zeros
  def render_zero_axis
    drawer.axis(
      # X - 0
      image.calc_bitmap_x(0.0).to_i,
      # Y - 0
      image.calc_bitmap_y(0.0).to_i,
      # options, slightly wider
      { :color => options[:axis_color], :width => 2 },
      # draw label
      options[:axis_zero_labels],
      # X label,
      [0.0],
      # Y label
      [0.0]
    )
  end


  def render_axis_labels
    drawer.axis_labels(
      options[:x_axis_label].to_s,
      options[:y_axis_label].to_s,
      {
        :color => options[:axis_color],
        :width => 1,
        :size => options[:axis_label_font_size],
      }
    )
  end

end