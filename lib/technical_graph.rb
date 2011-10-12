#encoding: utf-8

require 'rubygems'
require 'technical_graph/data_layer'
require 'technical_graph/graph_data_processor'
require 'technical_graph/graph_image_drawer'
require 'technical_graph/graph_axis'

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
    @data_processor = GraphDataProcessor.new(self)
    @image_drawer = GraphImageDrawer.new(self)
    @axis = GraphAxis.new(self)
    @layers = Array.new
  end
  attr_reader :options
  attr_reader :data_processor
  attr_reader :image_drawer
  attr_reader :axis

  attr_reader :layers

  # Add new data layer to layer array
  def add_layer(data = [], options = {})
    @layers << DataLayer.new(data, options)
  end

  # Create graph
  def render
    @image = @image_drawer.crate_blank_graph_image
    # recalculate ranges if needed
    @layers.each do |l|
      @data_processor.process_data_layer(l)
    end
    
    # draw axis
    @axis.render_on_image(@image)
    # draw layers
    @layers.each do |l|
      # external processing
      l.process
      # drawing
      @image_drawer.render_data_layer(l)
    end
    # draw legend
    @image_drawer.render_data_legend
  end
end
