#encoding: utf-8

require 'technical_graph/data_layer'

# Calculate every aspect of graph, but not directly image oriented variables

class GraphDataProcessor
  attr_reader :technical_graph

  # Accessor for options Hash
  def options
    @technical_graph.options
  end

  # Accessor for DataLayer Array
  def layers
    @technical_graph.layers
  end

  def initialize(technical_graph)
    @technical_graph = technical_graph

    # axis label
    options[:x_axis_label] ||= ''
    options[:y_axis_label] ||= ''

    options[:x_min] ||= 0.0 #(Time.now - 24 * 3600).to_f
    options[:x_max] ||= 1.0 #Time.now.to_f
    options[:y_min] ||= 0.0
    options[:y_max] ||= 1.0
    # :default - coords are default
    # :fixed or whatever else - min/max coords are fixed
    options[:xy_behaviour] ||= :default

    # number of axis
    options[:y_axis_count] ||= 10
    options[:x_axis_count] ||= 10
    # interval
    options[:y_axis_interval] ||= 1.0
    options[:x_axis_interval] ||= 1.0
    # when false then axis are generated to meet 'count'
    # when true then axis are generated every X from lowest
    options[:x_axis_fixed_interval] = true if options[:x_axis_fixed_interval].nil?
    options[:y_axis_fixed_interval] = true if options[:y_axis_fixed_interval].nil?

    # when set enlarge image so axis are located in sensible distance between themselves
    options[:axis_density_enlarge_image] = false if options[:x_axis_fixed_interval].nil?
    # distance in pixels
    options[:x_axis_min_distance] ||= 30
    # distance in pixels
    options[:y_axis_min_distance] ||= 50

    # default truncate string used for rendering numbers
    options[:truncate_string] ||= "%.2f"

    @zoom_x = 1.0
    @zoom_y = 1.0
  end

  # Ranges are fixed
  def fixed?
    options[:xy_behaviour] == :fixed
  end

  # Ranges without zoom
  def raw_x_min
    options[:x_min]
  end

  def raw_x_max
    options[:x_max]
  end

  def raw_y_min
    options[:y_min]
  end

  def raw_y_max
    options[:y_max]
  end

  # Ranges with zoom
  def x_min
    calc_x_zoomed([self.raw_x_min]).first
  end

  def x_max
    calc_x_zoomed([self.raw_x_max]).first
  end

  def y_min
    calc_y_zoomed([self.raw_y_min]).first
  end

  def y_max
    calc_y_zoomed([self.raw_y_max]).first
  end

  # Accessors
  private
  def raw_x_min=(x)
    options[:x_min] = x
  end

  def raw_x_max=(x)
    options[:x_max] = x
  end

  def raw_y_min=(y)
    options[:y_min] = y
  end

  def raw_y_max=(y)
    options[:y_max] = y
  end

  public

  # Consider changing ranges if needed
  def process_data_layer(data_layer)
    # ranges are set, can't change
    return if fixed?

    # updating ranges
    self.raw_y_max = data_layer.y_max if not data_layer.y_max.nil? and data_layer.y_max > self.raw_y_max
    self.raw_x_max = data_layer.x_max if not data_layer.x_max.nil? and data_layer.x_max > self.raw_x_max

    self.raw_y_min = data_layer.y_min if not data_layer.y_min.nil? and data_layer.y_min < self.raw_y_min
    self.raw_x_min = data_layer.x_min if not data_layer.x_min.nil? and data_layer.x_min < self.raw_x_min
  end

  # Change overall image zoom
  def zoom=(z = 1.0)
    self.x_zoom = z
    self.y_zoom = z
  end

  # Change X axis zoom
  def x_zoom=(z = 1.0)
    @zoom_x = z
  end

  # Change X axis zoom
  def y_zoom=(z = 1.0)
    @zoom_y = z
  end

  attr_reader :zoom_x, :zoom_y

  # Calculate zoomed X position for Array of X'es
  def calc_x_zoomed(old_xes)
    # default zoom
    if self.zoom_x == 1.0
      return old_xes
    end

    a = (raw_x_max.to_f + raw_x_min.to_f) / 2.0
    new_xes = Array.new

    old_xes.each do |x|
      d = x - a
      new_xes << (a + d * self.zoom_x)
    end

    return new_xes
  end

  # Calculate zoomed Y position for Array of Y'es
  def calc_y_zoomed(old_yes)
    # default zoom
    if self.zoom_y == 1.0
      return old_yes
    end

    a = (raw_y_max.to_f + raw_y_min.to_f) / 2.0
    new_yes = Array.new

    old_yes.each do |y|
      d = y - a
      new_yes << (a + d * self.zoom_y)
    end

    return new_yes
  end

end