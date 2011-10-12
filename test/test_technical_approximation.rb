require 'helper'

class TestTechnicalApproximation < Test::Unit::TestCase
  context 'calculations' do
    setup do
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

    should 'do some basic tests' do
      @processor.should.kind_of? DataLayerProcessor
    end

    should 'calculated vector has proper size and sum eq. 1.0' do
      return # TODO !!
      
      @processor.generate_vector.should.kind_of? Array
      @processor.generate_vector.size.should == @processor.level

      DataLayerProcessor::STRATEGIES.keys.each do |s|
        @processor.strategy = s
        @processor.strategy.should == s

        (1...10).each do |i|
          @processor.level = i
          @processor.level.should == i

          @processor.generate_vector.size.should == @processor.level

          s = 0.0
          @processor.generate_vector.each do |t|
            s += t
          end
          s.should be_within(0.01).of(1.0)

          # puts @processor.vector.inspect
        end
      end

    end

    should 'processed data has the same size that old one' do
      return # TODO !!
      
      DataLayerProcessor::STRATEGIES.keys.each do |s|
        @processor.strategy = s
        @processor.strategy.should == s
        (1...9).each do |i|
          @processor.level = i
          @processor.level.should == i

          @processor.generate_vector.size.should == @processor.level

          new_data = @processor.process
          new_data.size.should == @data_layer.data.size

          # add as new layer
          #@data_layer = DataLayer.new(@layer_data, @layer_params)
          # @tg.add_layer(new_data, @layer_params)
        end
      end
    end

    should 'create simple graph with unprocessed and processed layer (gauss)' do
      return # TODO !!

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
      approx.strategy = :gauss
      approx.level = 9
      approx.generate_vector
      
      layer_data_b = approx.process
      layer_params_b = {
        :antialias => false,
        :color => 'blue',
        :label => 'processed',
        :value_labels => false,
        # :simple_smother => 9
      }
      tg.add_layer(layer_data_b, layer_params_b)

      tg.render
      tg.image_drawer.save_to_file('samples/tests/test_simple_gauss.png')
    end

    should 'create simple graph using only layer params' do
      tg = TechnicalGraph.new(
        {
          :width => 4000,
          :height => 3000,

          :legend => true,
          :legend_auto => true,
          :legend_width => 90,
          :legend_margin => 60,
          :legend_x => 50,
          :legend_y => 50,
        }
      )
      max = 1000

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
      tg.add_layer(layer_data.clone, layer_params)
      layer_params_c = layer_params.clone.merge({
        :color => 'green',
        :label => 'processed - level 10',
        :simple_smoother_level => 10,
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


      tg.render
      tg.image_drawer.save_to_file('samples/tests/test_smoothing_multiple.png')
    end


  end

  context 'simple approximation' do
    should 'draw nice graph' do
      return # turned off

      max = 500

      # adding simple layer
      layer_params = {
        :antialias => true,
        :label => 'first',
        :value_labels => false,
        :simple_smother => 4
      }
      layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (0.5 * 3.14 / max.to_f))

        y += rand
        x += rand / 500.to_f

        layer_data << { :x => x, :y => y }
      end


      @tg = TechnicalGraph.new(
        {
          :width => 2000,
          :height => 1500,
        }
      )
      @tg.add_layer(layer_data, layer_params)

      @tg.render
      @tg.image_drawer.save_to_file('samples/test_approximation.png')
    end
  end

end
