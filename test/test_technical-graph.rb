require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'TechnicalGraph' do
    setup do
      @technical_graph = TechnicalGraph.new
    end

    should "has options with default values" do
      @technical_graph.options.class.should == Hash
      @technical_graph.options[:width] > 0
      @technical_graph.options[:height] > 0
    end

    should "has options with custom values" do
      s = 10
      tg = TechnicalGraph.new({:height => s, :width => s})
      @technical_graph.options[:width] == s
      @technical_graph.options[:height] == s

      @technical_graph.image.width == s
      @technical_graph.image.height == s
    end

    should "has changeable options" do
      s = 20
      tg = TechnicalGraph.new
      tg.image.width = s
      tg.image.height = s
      @technical_graph.options[:width] == s
      @technical_graph.options[:height] == s
    end
  end
end
