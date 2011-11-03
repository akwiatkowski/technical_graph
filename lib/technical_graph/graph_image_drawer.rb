#encoding: utf-8

require 'date'
require 'technical_graph/graph_image_drawer_rmagick'
require 'technical_graph/graph_image_drawer_rasem'

# Universal class for creating graphs/charts.

# options parameters:
# :width - width of image
# :height - height of image
# :x_min, :x_max, :y_min, :y_max - default or fixed ranges
# :xy_behaviour:
# * :default - use them as default ranges
# * :fixed - ranges will not be changed during addition of layers

class GraphImageDrawer

  def drawing_class
    #return GraphImageDrawerRmagick
    return GraphImageDrawerRasem
  end

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

  # Axis processing
  def graph_axis
    @technical_graph.axis
  end

  def logger
    @technical_graph.logger
  end

  def truncate_string
    options[:truncate_string]
  end

  def axis_font_size
    options[:axis_font_size]
  end


  # default sizes
  DEFAULT_WIDTH = 1600
  DEFAULT_HEIGHT = 1200

  def initialize(technical_graph)
    @technical_graph = technical_graph

    t = Time.now

    options[:width] ||= DEFAULT_WIDTH
    options[:height] ||= DEFAULT_HEIGHT

    options[:axis_value_and_param_labels] = true if options[:axis_value_and_param_labels].nil?
    options[:axis_zero_labels] = true if options[:axis_zero_labels].nil?

    # colors
    options[:background_color] ||= 'white'
    options[:background_hatch_color] ||= 'lightcyan2'
    options[:axis_color] ||= '#aaaaaa'

    # antialias
    options[:layers_antialias] = false if options[:layers_antialias].nil?
    options[:axis_antialias] = false if options[:axis_antialias].nil?
    options[:font_antialias] = false if options[:font_antialias].nil?

    # font sizes
    options[:axis_font_size] ||= 10
    options[:layers_font_size] ||= 10
    options[:axis_label_font_size] ||= 10

    # legend
    options[:legend] = false if options[:legend].nil?
    options[:legend_auto] = true if options[:legend_auto].nil?
    options[:legend_x] ||= 50
    options[:legend_y] ||= 50
    options[:legend_width] ||= 100
    options[:legend_margin] ||= 50

    # array of all points drawn on graph, used for auto positioning of legend
    @drawn_points = Array.new

    logger.debug "initializing #{self.class}"
    logger.debug " TIME COST #{Time.now - t}"
  end

  def width
    options[:width].to_i
  end

  def height
    options[:height].to_i
  end

  def width=(w)
    options[:width] = w.to_i if w.to_i > 0
  end

  def height=(h)
    options[:height] = h.to_i if h.to_i > 0
  end

  def font_antialias
    options[:font_antialias] == true
  end

  def draw_legend?
    options[:legend]
  end

  def legend_x
    options[:legend_x]
  end

  def legend_y
    options[:legend_y]
  end

  def legend_auto_position
    options[:legend_auto]
  end

  def legend_width
    options[:legend_width]
  end

  def legend_margin
    options[:legend_margin]
  end

  # Calculate image X position
  def calc_bitmap_x(_x)
    l = data_processor.x_max - data_processor.x_min
    offset = _x - data_processor.x_min
    return (offset.to_f * width.to_f) / l.to_f
  end

  # Calculate image Y position
  def calc_bitmap_y(_y)
    l = data_processor.y_max - data_processor.y_min
    #offset = _y - data_processor.y_min
    offset = data_processor.y_max - _y
    return (offset.to_f * height.to_f) / l.to_f
  end

  # Everything that must be done before creating image
  def pre_image_create_calculations
    # check axis density and enlarge if this option is on
    graph_axis.axis_distance_image_enlarge
  end

  # Create background image
  def crate_blank_graph_image
    pre_image_create_calculations
    # create drawing proxy
    @drawer = drawing_class.new(self)
  end

  attr_reader :drawer

  # Render data layer, calculate coords and execute proxy
  def render_data_layer(l)
    layer_data = l.processed_data

    t = Time.now

    # calculate coords, draw text, and then lines and circles
    coords = Array.new

    (0...(layer_data.size - 1)).each do |i|
      ax = layer_data[i].x
      ax = calc_bitmap_x(ax).round
      ay = layer_data[i].y
      ay = calc_bitmap_y(ay).round

      bx = layer_data[i+1].x
      bx = calc_bitmap_x(bx).round
      by = layer_data[i+1].y
      by = calc_bitmap_y(by).round

      coords << {
        :ax => ax, :ay => ay,
        :bx => bx, :by => by,
        :dy => layer_data[i].y
      }
    end

    logger.debug "rendering layer of size #{layer_data.size}, bitmap position calculation"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    # draw using proxy
    drawer.render_data_layer(l, coords)
  end

  # Used for auto position for legend
  def post_dot_drawn(bx, by)
    if legend_auto_position
      @drawn_points << { :x => bx, :y => by }
    end
  end

  # height of 1 layer
  ONE_LAYER_LEGEND_HEIGHT = 15

  # Choose best location
  def recalculate_legend_position
    return unless legend_auto_position
    logger.debug "Auto position calculation, drawn points #{@drawn_points.size}"

    legend_height = layers.size * ONE_LAYER_LEGEND_HEIGHT

    # check 8 places:
    positions = [
      { :x => legend_margin, :y => 0 + legend_margin }, # top-left
      { :x => width/2, :y => 0 + legend_margin }, # top-center
      { :x => width - legend_margin - legend_width, :y => 0 + legend_margin }, # top-right
      { :x => legend_margin, :y => height/2 }, # middle-left
      { :x => width - legend_margin - legend_width, :y => height/2 }, # middle-right
      { :x => legend_margin, :y => height - legend_margin - legend_height }, # bottom-left
      { :x => width/2, :y => height - legend_margin - legend_height }, # bottom-center
      { :x => width - legend_margin - legend_width, :y => height - legend_margin - legend_height }, # bottom-right
    ]

    t = Time.now

    # calculate nearest distance of all drawn points
    positions.each do |p|
      p[:distance] = (width ** 2 + height ** 2) ** 0.5 # max distance, diagonal of graph
      @drawn_points.each do |dp|
        # calculate drawn point distance to being checked now legend position
        two_points_distance = ((p[:x] - dp[:x]) ** 2 + (p[:y] - dp[:y]) ** 2) ** 0.5
        # modify only if distance is closer
        if p[:distance] > two_points_distance
          p[:distance] = two_points_distance
        end
      end
    end

    logger.debug "auto legend best position distance calc."
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    # chose position with highest distance
    positions.sort! { |a, b| a[:distance] <=> b[:distance] }
    best_position = positions.last
    options[:legend_x] = best_position[:x]
    options[:legend_y] = best_position[:y]

    logger.debug "Best position x #{options[:legend_x]}, y #{options[:legend_y]}, distance #{best_position[:distance]}"
    logger.debug " TIME COST #{Time.now - t}"
  end

  # Render legend on graph
  def render_data_legend
    return unless draw_legend?
    recalculate_legend_position

    x = legend_x
    y = legend_y

    legend_data = Array.new

    layers.each do |l|
      h = Hash.new
      h[:color] = l.color
      h[:label] = l.label
      h[:x] = x
      h[:y] = y
      
      legend_data << h
      y += ONE_LAYER_LEGEND_HEIGHT
    end

    drawer.legend(legend_data)
  end

  # Save output to file
  def save_to_file(file)
    t = Time.now

    drawer.save(file)

    logger.debug "saving image"
    logger.debug " TIME COST #{Time.now - t}"
  end

  # Export image
  def to_format(format)
    t = Time.now

    blob = drawer.to_format(format)

    logger.debug "exporting image as string"
    logger.debug " TIME COST #{Time.now - t}"

    return blob
  end

  # Return binary PNG
  def to_png
    to_format('png')
  end


end
