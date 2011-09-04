#encoding: utf-8

require 'rubygems'
require 'technical_graph/graph_image'
require 'technical_graph/data_layer'
require 'technical_graph/axis_layer'

# Universal class for creating graphs/charts.

# options parameters:
# :width - width of image
# :height - height of image
# :x_min, :x_max, :y_min, :y_max - default or fixed ranges
# :xy_behaviour:
# * :default - use them as default ranges
# * :fixed - ranges will not be changed during addition of layers

class TechnicalGraph

  def initialize(options = { })
    @options = options
    @image = GraphImage.new(@options)
    @axis = AxisLayer.new(@options)
    @layers = []
  end
  attr_reader :options
  attr_reader :image
  attr_reader :layers
  attr_reader :axis

  # Add new data layer to layer array
  def add_layer(data = [], options = {})
    @layers << DataLayer.new(data, options)
  end

  # Create graph
  def render
    @image.render_image
    # recalculate ranges
    @layers.each do |l|
      @axis.process_data_layer(l)
    end
    # draw axis
    @axis.render_on_image(@image)
    # draw layers
    @layers.each do |l|
      # @xis used for calculation purpose
      l.render_on_image(@image, @axis)
    end
  end

end
