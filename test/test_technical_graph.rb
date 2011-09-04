require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'initial options' do
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
      tg = TechnicalGraph.new({ :height => s, :width => s })
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

  context 'basic layer operation' do
    setup do
      @tg = TechnicalGraph.new

      # sample data
      @data = Array.new
      @second_data = Array.new
      (0..100).each do |i|
        @data << { :x => Time.now.to_i - 3600 + i, :y => Math.sin(i.to_f / 10.0) }
        @second_data << { :x => Time.now.to_i - 3600 + i*2, :y => Math.cos(i.to_f / 10.0) }
      end
    end

    should 'has ability do add new layer' do
      layers = @tg.layers.size
      @tg.add_layer(@data)
      @tg.layers.size.should == layers + 1
    end

    should 'has ability to manipulate layers, add more data' do
      @tg.add_layer(@data)
      layer = @tg.layers.last
      layer.class.should == DataLayer

      layer.data
      @second_data
    end
  end


end
