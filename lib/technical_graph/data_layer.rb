#encoding: utf-8

require 'technical_graph/data_point'
require 'technical_graph/graph_color_library'
require 'technical_graph/data_layer_processor'

# Stores only data used for one layer
# Instances of this class are used elsewhere
# Stores also drawing parameters for one layer

class DataLayer

  def initialize(d = [], options = { })
    @data_params = options

    @data_params[:color] ||= GraphColorLibrary.instance.get_color
    @data_params[:label] ||= ''
    # default true, write values near dots
    @data_params[:value_labels] = false if options[:value_labels] == false

    # smoothing parameters
    # by default it is false
    @data_params[:simple_smoother] = true if options[:simple_smoother] == true
    @data_params[:simple_smoother_x] = true if options[:simple_smoother_x] == true
    @data_params[:simple_smoother_level] ||= 3
    @data_params[:simple_smoother_strategy] ||= DataLayerProcessor::DEFAULT_SIMPLE_SMOOTHER_STRATEGY
    # was already done
    @data_params[:processor_finished] = false

    @processor = DataLayerProcessor.new(self)

    # set data and append initial data
    clear_data
    append_data(d)
  end

  # can be used to approximation and other data processing
  attr_reader :processor

  # Accessor for setting chart data for layer to draw
  def append_data(data_array)
    if data_array.kind_of? Array
      # append as DataPoint
      # convert to DataPoints, which has more specialized methods
      data_array.each do |d|
        @data << DataPoint.new(d)
      end
      
      # sort, clean bad records
      process_data
    else
      raise 'Data not an Array'
    end
  end

  # Array of DataPoints, not processed
  def raw_data
    @data
  end

  # Array of DataPoints, after external processing
  def processed_data
    if @processed_data.nil?
      process!
    end

    @processed_data
  end

  # Run external processor (smoothing, ...)
  def process!
    if simple_smoother
      @processor.simple_smoother_strategy = simple_smoother_strategy
      @processor.level = simple_smoother_level
      @processor.simple_smoother_x = simple_smoother_x
      @processed_data = @processor.process
    end
  end

  # Additional parameters
  attr_reader :data_params

  # Color of
  def color
    return @data_params[:color]
  end

  def antialias
    return @data_params[:antialias]
  end

  def label
    return @data_params[:label]
  end

  # Write values near dots
  def value_labels
    return @data_params[:value_labels]
  end

  # Turn on smoothing processor
  def simple_smoother
    return @data_params[:simple_smoother]
  end

  # Smoother level
  def simple_smoother_level
    return @data_params[:simple_smoother_level]
  end

  # Smoother strategy
  def simple_smoother_strategy
    return @data_params[:simple_smoother_strategy]
  end

  def simple_smoother_x
    return @data_params[:simple_smoother_x]
  end

  # Clear data
  def clear_data
    @data = Array.new
  end

  # Clean and process data used for drawing current data layer
  def process_data
    # delete duplicates
    @data = @data.inject([]) { |result, d| result << d unless result.select { |r| r.x == d.x }.size > 0; result }

    @data.delete_if { |d| d.x.nil? or d.y.nil? }
    @data.sort! { |d, e| d.x <=> e.x }

    # default X values, if data is not empty
    if @data.size > 0
      @data_params[:x_min] = @data.first.x || @options[:default_x_min]
      @data_params[:x_max] = @data.last.x || @options[:default_x_max]

      # default Y values
      y_sort = @data.sort { |a, b| a.y <=> b.y }
      @data_params[:y_min] = y_sort.first.y || @options[:default_y_min]
      @data_params[:y_max] = y_sort.last.y || @options[:@default_y_max]
    end
  end

  def x_min
    @data_params[:x_min]
  end

  def x_max
    @data_params[:x_max]
  end

  def y_min
    @data_params[:y_min]
  end

  def y_max
    @data_params[:y_max]
  end

end