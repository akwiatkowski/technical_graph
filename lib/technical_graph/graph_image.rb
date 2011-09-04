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

class GraphImage

  # default sizes
  DEFAULT_WIDTH = 1600
  DEFAULT_HEIGHT = 1200

  def initialize(options = { })
    @options = options
    @options[:width] ||= DEFAULT_WIDTH
    @options[:height] ||= DEFAULT_HEIGHT

    # colors
    @options[:background_color] ||= 'white'
    @options[:background_hatch_color] ||= 'lightcyan2'
  end

  def width
    @options[:width].to_i
  end

  def height
    @options[:height].to_i
  end

  def width=(w)
    @options[:width] = w.to_i if w.to_i > 0
  end

  def height=(h)
    @options[:height] = h.to_i if h.to_i > 0
  end

  def calc_bitmap_position( array )
    
  end

  def calc_bitmap_x( _x )

  end

  def calc_bitmap_y( _y )
    
  end

  # Create background image
  def render_image
    @image = Magick::ImageList.new
    @image.new_image(
      width,
      height,
      Magick::HatchFill.new(
        @options[:background_color],
        @options[:background_hatch_color]
      )
    )

    return @image
  end


end

