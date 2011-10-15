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

      @technical_graph.image_drawer.width == s
      @technical_graph.image_drawer.height == s
    end

    should "has changeable options" do
      s = 20
      tg = TechnicalGraph.new
      tg.image_drawer.width = s
      tg.image_drawer.height = s
      @technical_graph.options[:width] == s
      @technical_graph.options[:height] == s
    end
  end

  context 'basic layer operation and saving file' do
    setup do
      @tg = TechnicalGraph.new
      @data_size = 100

      # sample data
      @data = Array.new
      @second_data = Array.new
      (0...@data_size).each do |i|
        @data << { :x => Time.now.to_i - 3600 + i, :y => Math.sin(i.to_f / 10.0) }
        @second_data << { :x => Time.now.to_i - 1800 + i*2, :y => Math.cos(i.to_f / 10.0) }
      end
    end

    should 'has ability do add new layer' do
      layers = @tg.layers.size
      @tg.add_layer(@data)
      @tg.layers.size.should == layers + 1

      layer = @tg.layers.last
      layer.raw_data.size.should == @data_size
      layer.processed_data.size.should == @data_size
    end

    should 'has ability to manipulate layers, add more data' do
      @tg.add_layer(@data)
      layer = @tg.layers.last
      layer.class.should == DataLayer

      layer.raw_data.size.should == @data_size
      layer.processed_data.size.should == @data_size

      # adding second data
      layer.append_data(@second_data)
      layer.raw_data.size.should == 2 * @data_size
      layer.processed_data.size.should == 2 * @data_size

      # @tg.render
      # @tg.image.save_to_file('samples/tests/test1.png')
    end

    should 'has ability to filter records with similar x\'es' do
      @tg.add_layer
      layer = @tg.layers.last
      layer.raw_data.size.should == 0
      layer.processed_data.size.should == 0
      layer.append_data([{ :x => 0, :y => 1 }])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1

      # uniq check
      layer.append_data([{ :x => 0, :y => 1 }])
      layer.append_data([{ :x => 0, :y => 1 }])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1
      layer.append_data([{ :x => 2, :y => 1 }])
      layer.raw_data.size.should == 2
      layer.processed_data.size.should == 2
    end

    should 'has ability to filter bad records' do
      @tg.add_layer
      layer = @tg.layers.last
      layer.raw_data.size.should == 0
      layer.processed_data.size.should == 0
      layer.append_data([{ :x => 0, :y => 1 }])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1

      # uniq check
      layer.append_data([{ :z => 0, :y => 1 }])
      layer.append_data([{}])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1
    end

  end


end
