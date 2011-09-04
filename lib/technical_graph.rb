#encoding: utf-8

require 'rubygems'
require 'technical_graph/graph_image'

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
  end
  attr_reader :options
  attr_reader :image

end
