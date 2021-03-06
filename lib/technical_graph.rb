#encoding: utf-8

require 'rubygems'
require 'logger'
require 'technical_graph/gem'
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

    @log_device = options[:log_device] || STDOUT
    @logger = Logger.new(@log_device)
    @logger.level = options[:log_level] || Logger::INFO

    @data_processor = GraphDataProcessor.new(self)
    @image_drawer = GraphImageDrawer.new(self)
    @axis = GraphAxis.new(self)
    @layers = Array.new
  end

  attr_reader :options, :data_processor, :image_drawer, :axis, :layers, :logger

  # Best output image format, used for testing
  def best_output_format
    if options[:drawer_class] == :rasem
      return 'svg'
    end
    if options[:drawer_class] == :rmagick
      return 'png'
    end
  end

  # Add new data layer to layer array
  def add_layer(data = [], options = { })
    t = Time.now
    @layers << DataLayer.new(data, options, self)
    logger.debug "layer added, size #{data.size}"
    logger.debug " TIME COST #{Time.now - t}"
  end

  # Create graph
  def render
    @layers.each do |l|
      @data_processor.process_data_layer(l)
    end

    # recalculate ranges if needed
    @image = @image_drawer.crate_blank_graph_image

    # draw axis
    @axis.render_on_image(@image)
    # draw layers
    @layers.each do |l|
      # drawing
      @image_drawer.render_data_layer(l)
    end
    # draw legend
    @image_drawer.render_data_legend
  end

  # Render and save graph to a file
  def save_to_file(filename)
    ext = File.extname(filename).gsub(/^\./, '')
    pre_render(ext)
    @image_drawer.save_to_file(filename)
  end

  # Render and return graph string
  def to_format(ext)
    pre_render(ext)
    @image_drawer.to_format(ext)
  end

  # You don't have to run this
  def pre_render(ext)
    case ext
      when 'svg', 'svgz' then
        @options[:drawer_class] = :rasem
        render

      when 'png' then
        if gem_available?('rmagick')
          # rmagick is at the moment the best solution
          @options[:drawer_class] = :rmagick
        else
          @options[:drawer_class] = :chunky_png
        end
        render

      when 'jpeg', 'jpg', 'bmp', 'gif' then
        if rmagick_installed?
          @options[:drawer_class] = :rmagick
          render
        else
          raise Gem::LoadError
        end

      else
        raise ArgumentError

    end
  end

end
