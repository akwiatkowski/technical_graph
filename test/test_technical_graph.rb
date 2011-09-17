require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'initial options' do
    setup do
      @technical_graph = TechnicalGraph.new
    end

    should "has options with default values" do
      puts @technical_graph.options.inspect, "*"*100
      @technical_graph.options.class.should == Hash
      @technical_graph.options[:width] > 0
      @technical_graph.options[:height] > 0
    end
  end

end
