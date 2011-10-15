#encoding: utf-8

require 'technical_graph/data_layer_processor_simple_smoother'
require 'technical_graph/data_layer_processor_noise_removal'

# Smooth data layer, approximate, ..

class DataLayerProcessor
  include DataLayerProcessorSimpleSmoother
  include DataLayerProcessorNoiseRemoval

  def initialize(data_layer)
    @data_layer = data_layer
    simple_smoother_initialize
    noise_removal_initialize
  end
  

  def process
    # before processing old processed data is overwritten by cloned raw data
    @data = @data_layer.processed_data
    simple_smoother_process
    return @data
  end
end