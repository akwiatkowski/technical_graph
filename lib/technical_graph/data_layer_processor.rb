#encoding: utf-8

require 'technical_graph/data_layer_processor_simple_smoother'
require 'technical_graph/data_layer_processor_noise_removal'

# Smooth data layer, approximate, ..

class DataLayerProcessor
  include DataLayerProcessorSimpleSmoother
  include DataLayerProcessorNoiseRemoval

  def logger
    @data_layer.logger
  end

  def initialize(data_layer)
    @data_layer = data_layer
    simple_smoother_initialize(data_params)
    noise_removal_initialize(data_params)
  end

  # Additional layer parameters, processors options
  def data_params
    @data_layer.data_params
  end

  # Data from DataLayer, not raw data
  def data
    @data_layer.processed_data
  end

  def process
    # before processing old processed data is overwritten by cloned raw data
    @data = data

    # update params before processing
    simple_smoother_initialize(data_params)
    noise_removal_initialize(data_params)

    noise_removal_process
    simple_smoother_process
    
    return @data
  end
end