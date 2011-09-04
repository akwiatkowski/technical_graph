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
    @options[:x_min] ||= (Time.now - 24 * 3600).to_f
    @options[:x_max] ||= Time.now.to_f
    @options[:y_min] ||= 0.0
    @options[:y_max] ||= 1.0
    # :default - coords are default
    # :zoom or whatever else - min/max coords are fixed
    @options[:xy_behaviour] ||= :default
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


end

