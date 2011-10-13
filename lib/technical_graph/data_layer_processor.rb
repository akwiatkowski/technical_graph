#encoding: utf-8

require 'technical_graph/data_layer_processor_simple_smoother'

# Smooth data layer, approximate, ..

class DataLayerProcessor
  include DataLayerProcessorSimpleSmoother

  def process
    return simple_smoother_process
  end
end