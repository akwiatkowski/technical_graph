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
      ax = l.data[i][:x]
      ax = calc_bitmap_x(ax).round
      ay = l.data[i][:y]
      ay = calc_bitmap_y(ay).round

      bx = l.data[i+1][:x]
      bx = calc_bitmap_x(bx).round
      by = l.data[i+1][:y]
      by = calc_bitmap_y(by).round

      coords << {
        :ax => ax, :ay => ay,
        :bx => bx, :by => by,
        :dy => l.data[i][:y]
      }
    end

    # labels
    coords.each do |c|
      string_label = "#{truncate_string % c[:dy]}"
      layer_text.text(
        c[:ax] + 5, c[:ay],
        string_label
      )
    end
    layer_text.draw(@image)

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
    end
    layer_line.draw(@image)

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
