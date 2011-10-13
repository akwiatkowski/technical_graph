#encoding: utf-8

require 'technical_graph/data_layer_processor_simple_smoother'

# Smooth data layer, approximate, ..

class DataLayerProcessor
  include DataLayerProcessorSimpleSmoother

  def initialize(data_layer)
    @data_layer = data_layer
    simple_smoother_initialize
  end
  

  def process
    # before processing old processed data is overwritten by cloned raw data
    @data = @data_layer.processed_data
    simple_smoother_process
    return @data
  end
end