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

  # Create background image
  def crate_blank_graph_image
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

    layer_line.stroke_antialias(l.antialias)
    layer_line.fill_opacity(0)
    layer_line.stroke(l.color)
    layer_line.stroke_opacity(1.0)
    layer_line.stroke_width(1.0)
    layer_line.stroke_linecap('square')
    layer_line.stroke_linejoin('miter')

    layer_text.text_antialias(font_antialias)
    layer_text.pointsize(10)
    layer_text.font_family('helvetica')
    layer_text.font_style(Magick::NormalStyle)
    layer_text.text_align(Magick::LeftAlign)
    layer_text.text_undercolor(options[:background_color])


    (0...(l.data.size - 1)).each do |i|
      ax = l.data[i][:x]
      ax = calc_bitmap_x(ax).round
      ay = l.data[i][:y]
      ay = calc_bitmap_y(ay).round

      bx = l.data[i+1][:x]
      bx = calc_bitmap_x(bx).round
      by = l.data[i+1][:y]
      by = calc_bitmap_y(by).round

      layer_line.line(
        ax, ay,
        bx, by
      )

      layer_text.text(
        ax, ay,
        "(#{l.data[i][:x]},#{l.data[i][:y]})"
      )
    end

    layer_line.draw(@image)
    layer_text.draw(@image)


  end

  # Save output to file
  def save_to_file(file)
    @image.write(file)
  end


end

