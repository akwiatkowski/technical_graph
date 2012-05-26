require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DataLayerProcessorSimpleSmoother do
  context 'using smoother' do
    before :each do
      max = 500

      # adding simple layer
      @layer_params = {
        :antialias => true,
        :label => 'first',
        :value_labels => false,
        :simple_smother => 4
      }
      @layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (0.5 * 3.14 / max.to_f))

        y += rand
        x += rand / max.to_f

        @layer_data << { :x => x, :y => y }
      end


      @data_layer = DataLayer.new(@layer_data, @layer_params)
      @processor = @data_layer.processor
    end


    it 'do some basic tests' do
      @processor.should.kind_of? DataLayerProcessor
    end

    it 'calculated vector has proper size and sum eq. 1.0' do
      @processor.generate_vector.should.kind_of? Array
      @processor.generate_vector.size.should == @processor.simple_smoother_level

      DataLayerProcessor::SIMPLE_SMOOTHER_STRATEGIES.keys.each do |s|
        @processor.simple_smoother_strategy = s
        @processor.simple_smoother_strategy.should == s

        (1...10).each do |i|
          @processor.simple_smoother_level = i
          @processor.simple_smoother_level.should == i

          @processor.generate_vector.size.should == @processor.simple_smoother_level

          s = 0.0
          @processor.generate_vector.each do |t|
            s += t
          end
          s.should be_within(0.01).of(1.0)

          # puts @processor.vector.inspect
        end
      end

    end

    it 'processed data has the same size that old one' do
      DataLayerProcessor::SIMPLE_SMOOTHER_STRATEGIES.keys.each do |s|
        @processor.simple_smoother_strategy = s
        @processor.simple_smoother_strategy.should == s
        (1...9).each do |i|
          @processor.simple_smoother_level = i
          @processor.simple_smoother_level.should == i

          @processor.generate_vector.size.should == @processor.simple_smoother_level

          new_data = @processor.process
          new_data.size.should == @data_layer.raw_data.size
          new_data.size.should == @data_layer.processed_data.size

          # add as new layer
          #@data_layer = DataLayer.new(@layer_data, @layer_params)
          # @tg.add_layer(new_data, @layer_params)
        end
      end
    end

    it 'create simple graph with unprocessed and processed layer (gauss)' do
      tg = TechnicalGraph.new(
        {
          :width => 2000,
          :height => 1500,
        }
      )
      max = 1000

      # adding simple layer
      layer_params = {
        :antialias => true,
        :color => 'red',
        :label => 'raw',
        :value_labels => false,
        # :simple_smother => 8
      }
      layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (0.5 * 3.14 / max.to_f))

        y += rand
        x += rand / max.to_f

        layer_data << { :x => x, :y => y }
      end

      # non processed
      tg.add_layer(layer_data, layer_params)

      # process and add
      approx = layer_data_b = tg.layers[0].processor
      approx.simple_smoother_strategy = :gauss
      approx.simple_smoother_level = 9

      layer_data_b = approx.process
      layer_params_b = {
        :antialias => false,
        :color => 'blue',
        :label => 'processed',
        :value_labels => false,
        # :simple_smother => 9
      }
      tg.add_layer(layer_data_b, layer_params_b)

      tg.save_to_file("tmp/test_simple_gauss.svg")
    end

    it 'create simple graph using only layer params' do
      tg = TechnicalGraph.new(
        {
          :width => 5000,
          :height => 3000,

          :legend => true,
          :legend_auto => true,
          :legend_width => 90,
          :legend_margin => 60,
          :legend_x => 50,
          :legend_y => 50,
        }
      )
      max = 2000

      layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (2.0 * 3.14 / max.to_f))

        y += rand * 4.0
        x += rand / max.to_f

        layer_data << { :x => x, :y => y }
      end

      # adding simple layer
      layer_params = {
        :antialias => false,
        :color => 'red',
        :label => 'raw',
        :value_labels => false,
        :simple_smoother => true,
        :simple_smoother_level => 1,
        :simple_smoother_strategy => :gauss
      }
      #tg.add_layer(layer_data.clone, layer_params)
      #layer_params_b = layer_params.merge({
      #  :color => 'blue',
      #  :label => 'processed - level 3',
      #  :simple_smoother_level => 3,
      #  :simple_smoother => true
      #})
      #tg.add_layer(layer_data.clone, layer_params)
      layer_params_c = layer_params.clone.merge(
        {
          :color => 'green',
          :label => 'processed - level 100',
          :simple_smoother_level => 100,
          :simple_smoother => true
        })
      #tg.add_layer(layer_data.clone, layer_params)
      #layer_params_d = layer_params.clone.merge({
      #  :color => 'brown',
      #  :label => 'processed - level 50',
      #  :simple_smoother_level => 50,
      #  :simple_smoother => true
      #})
      tg.add_layer(layer_data.clone, layer_params)
      #tg.add_layer(layer_data.clone, layer_params_b)
      tg.add_layer(layer_data.clone, layer_params_c)
      #tg.add_layer(layer_data.clone, layer_params_d)


      layer_params_e = layer_params.clone.merge(
        {
          :color => 'blue',
          :label => 'processed (rectangular) - level 100',
          :simple_smoother_level => 100,
          :simple_smoother => true,
          :simple_smoother_strategy => :rectangular
        })
      tg.add_layer(layer_data.clone, layer_params_e)

      tg.save_to_file("tmp/test_smoothing_multiple.svg")
    end


  end


end
