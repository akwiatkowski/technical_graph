require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TechnicalGraph do
  context 'creating simple graph' do
    before :each do
      @technical_graph = TechnicalGraph.new
    end

    it "has options with default values" do
      @technical_graph.options.class.should == Hash
      @technical_graph.options[:width] > 0
      @technical_graph.options[:height] > 0
    end

    it "has options with custom values" do
      s = 10
      tg = TechnicalGraph.new({ :height => s, :width => s })
      @technical_graph.options[:width] == s
      @technical_graph.options[:height] == s

      @technical_graph.image_drawer.width == s
      @technical_graph.image_drawer.height == s
    end

    it "has changeable options" do
      s = 20
      tg = TechnicalGraph.new
      tg.image_drawer.width = s
      tg.image_drawer.height = s
      @technical_graph.options[:width] == s
      @technical_graph.options[:height] == s
    end
  end

  context 'basic layer operation' do
    before :each do
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

    it 'has ability do add new layer' do
      layers = @tg.layers.size
      @tg.add_layer(@data)
      @tg.layers.size.should == layers + 1

      layer = @tg.layers.last
      layer.raw_data.size.should == @data_size
      layer.processed_data.size.should == @data_size
    end

    it 'has ability to manipulate layers, add more data' do
      @tg.add_layer(@data)
      layer = @tg.layers.last
      layer.class.should == DataLayer

      layer.raw_data.size.should == @data_size
      layer.processed_data.size.should == @data_size

      # adding second data
      layer.append_data(@second_data)
      layer.raw_data.size.should == 2 * @data_size
      layer.processed_data.size.should == 2 * @data_size
    end

    it 'has ability to filter records with similar x\'es' do
      # was turned off by default, performance issue
      @tg.add_layer([], { :perform_parameter_uniq => true })
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

    it 'has ability to filter bad records' do
      @tg.add_layer
      layer = @tg.layers.last
      layer.raw_data.size.should == 0
      layer.processed_data.size.should == 0
      layer.append_data([{ :x => 0, :y => 1 }])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1

      # uniq check
      layer.append_data([{ :z => 0, :y => 1 }])
      layer.append_data([{ }])
      layer.raw_data.size.should == 1
      layer.processed_data.size.should == 1
    end

  end


end
