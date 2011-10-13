#encoding: utf-8

require 'rubygems'
require 'RMagick'
require 'date'

# Universal class for creating graphs/charts.

# options parameters:
# :width - width of image
# :height - height of image
# :x_min, :x_max, :y_min, :y_max - default or fixed ranges
# :xy_behaviour:
# * :default - use them as default ranges
# * :fixed - ranges will not be changed during addition of layers

class GraphImageDrawer

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

    options[:width] ||= DEFAULT_WIDTH
    options[:height] ||= DEFAULT_HEIGHT

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

    @image = Magick::ImageList.new
    @image.new_image(
      width,
      height,
      Magick::HatchFill.new(
        options[:background_color],
        options[:background_hatch_color]
      )
    )

    return @image
  end

  attr_reader :image

  # Render data layer
  def render_data_layer(l)
    layer_line = Magick::Draw.new
    layer_text = Magick::Draw.new

    # global layer antialias can be override using layer option
    layer_antialias = l.antialias
    layer_antialias = options[:layers_antialias] if layer_antialias.nil?

    layer_line.stroke_antialias(layer_antialias)
    layer_line.fill(l.color)
    layer_line.fill_opacity(1)
    layer_line.stroke(l.color)
    layer_line.stroke_opacity(1.0)
    layer_line.stroke_width(1.0)
    layer_line.stroke_linecap('square')
    layer_line.stroke_linejoin('miter')

    layer_text.text_antialias(font_antialias)
    layer_text.pointsize(options[:layers_font_size])
    layer_text.font_family('helvetica')
    layer_text.font_style(Magick::NormalStyle)
    layer_text.text_align(Magick::LeftAlign)
    layer_text.text_undercolor(options[:background_color])

    # calculate coords, draw text, and then lines and circles
    coords = Array.new

    (0...(l.data.size - 1)).each do |i|
      ax = l.data[i].x
      ax = calc_bitmap_x(ax).round
      ay = l.data[i].y
      ay = calc_bitmap_y(ay).round

      bx = l.data[i+1].x
      bx = calc_bitmap_x(bx).round
      by = l.data[i+1].y
      by = calc_bitmap_y(by).round

      coords << {
        :ax => ax, :ay => ay,
        :bx => bx, :by => by,
        :dy => l.data[i].y
      }
    end

    # labels
    if l.value_labels
      coords.each do |c|
        string_label = "#{truncate_string % c[:dy]}"
        layer_text.text(
          c[:ax] + 5, c[:ay],
          string_label
        )
      end
      layer_text.draw(@image)
    end

    # lines and circles
    coords.each do |c|
      # additional circle
      layer_line.circle(
        c[:ax], c[:ay],
        c[:ax] + 3, c[:ay]
      )
      layer_line.circle(
        c[:bx], c[:by],
        c[:bx] + 3, c[:by]
      )

      # line
      layer_line.line(
        c[:ax], c[:ay],
        c[:bx], c[:by]
      )

      # used for auto positioning of legend
      if legend_auto_position
        @drawn_points << { :x => c[:ax], :y => c[:ay] }
        @drawn_points << { :x => c[:bx], :y => c[:by] }
      end
    end
    layer_line.draw(@image)

  end

  # height of 1 layer
  ONE_LAYER_LEGEND_HEIGHT = 15

  # Choose best location
  def recalculate_legend_position
    return unless legend_auto_position
    puts "Auto position calculation, drawn points #{@drawn_points.size}"

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

    # chose position with hihest distance
    positions.sort! { |a, b| a[:distance] <=> b[:distance] }
    best_position = positions.last
    options[:legend_x] = best_position[:x]
    options[:legend_y] = best_position[:y]

    puts "Best position x #{options[:legend_x]}, y #{options[:legend_y]}, distance #{best_position[:distance]}"
    # puts positions.to_yaml
  end

  # Render legend on graph
  def render_data_legend
    return unless draw_legend?

    recalculate_legend_position

    legend_text = Magick::Draw.new
    legend_text_antialias = options[:layers_font_size]
    legend_text.stroke_antialias(legend_text_antialias)
    legend_text.text_antialias(legend_text_antialias)
    legend_text.pointsize(options[:axis_font_size])
    legend_text.font_family('helvetica')
    legend_text.font_style(Magick::NormalStyle)
    legend_text.text_align(Magick::LeftAlign)
    legend_text.text_undercolor(options[:background_color])

    x = legend_x
    y = legend_y

    layers.each do |l|
      legend_text.fill(l.color)

      string_label = l.label
      legend_text.text(
        x, y,
        string_label
      )

      # little dot
      legend_text.circle(
        x - 10, y,
        x - 10 + 3, y
      )

      y += ONE_LAYER_LEGEND_HEIGHT
    end
    legend_text.draw(@image)
  end

  # Save output to file
  def save_to_file(file)
    @image.write(file)
  end

  # Export image
  def to_format(format)
    i = @image.flatten_images
    i.format = format
    return i.to_blob
  end

  # Return binary PNG
  def to_png
    to_format('png')
  end


end
