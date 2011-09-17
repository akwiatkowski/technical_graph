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

  # Calculate image X position
  def calc_bitmap_x(_x)
    l = self.x_max - self.x_min
    offset = _x - self.x_min
    return (offset.to_f * @image.width.to_f) / l.to_f
  end

  # Calculate image Y position
  def calc_bitmap_y(_y)
    l = self.y_max - self.y_min
    offset = _y - self.y_min
    return (offset.to_f * @image.width.to_f) / l.to_f
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

  # Save output to file
  def save_to_file(file)
    @image.write(file)
  end


end

