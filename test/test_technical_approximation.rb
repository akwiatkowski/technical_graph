require 'helper'

class TestTechnicalApproximation < Test::Unit::TestCase
  context 'calculations' do
    setup do
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


      @dl = DataLayer.new(layer_data, layer_params)
      @approximator = @dl.approximator
    end

    should 'do some basic tests' do
      @approximator.should.kind_of? DataLayerApproximator
    end

    should 'calculate vector' do
      @approximator.generate_vector.should.kind_of? Array
      @approximator.generate_vector.size.should == @approximator.level
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
