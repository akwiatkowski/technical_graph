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
        :simple_approximate => 4
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
      @approximator = @data_layer.approximator
    end

    should 'do some basic tests' do
      @approximator.should.kind_of? DataLayerApproximator
    end

    should 'calculated vector has proper size and sum eq. 1.0' do
      @approximator.generate_vector.should.kind_of? Array
      @approximator.generate_vector.size.should == @approximator.level

      DataLayerApproximator::STRATEGIES.keys.each do |s|
        @approximator.strategy = s
        @approximator.strategy.should == s

        (1...10).each do |i|
          @approximator.level = i
          @approximator.level.should == i

          @approximator.generate_vector.size.should == @approximator.level

          s = 0.0
          @approximator.generate_vector.each do |t|
            s += t
          end
          s.should be_within(0.01).of(1.0)

          # puts @approximator.vector.inspect
        end
      end

    end

    should 'processed data has the same size that old one' do
      DataLayerApproximator::STRATEGIES.keys.each do |s|
        @approximator.strategy = s
        @approximator.strategy.should == s
        (1...9).each do |i|
          @approximator.level = i
          @approximator.level.should == i

          @approximator.generate_vector.size.should == @approximator.level

          new_data = @approximator.process
          new_data.size.should == @data_layer.data.size

          # add as new layer
          #@data_layer = DataLayer.new(@layer_data, @layer_params)
          # @tg.add_layer(new_data, @layer_params)
        end
      end
    end

    should 'create simple graph with unprocessed and processed layer (gauss)' do
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
        :label => 'first',
        :value_labels => false,
        :simple_approximate => 8
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
      approx = layer_data_b = tg.layers[0].approximator
      approx.strategy = :gauss
      approx.level = 2
      approx.generate_vector
      
      layer_data_b = approx.process
      layer_params_b = {
        :antialias => true,
        :color => 'blue',
        :label => 'first',
        :value_labels => false,
        :simple_approximate => 8
      }
      tg.add_layer(layer_data_b, layer_params_b)

      tg.render
      tg.image_drawer.save_to_file('samples/test_approximation2_gauss.png')
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
        :simple_approximate => 4
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
