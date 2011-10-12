require 'helper'

class TestTechnicalApproximation < Test::Unit::TestCase
  context 'simple approximation' do
    should 'draw nice graph' do
      max = 5_000

      # adding simple layer
      layer_params = {
        :antialias => true,
        :label => 'first'
      }
      layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (8.0 * 3.14 / max.to_f))

        y += rand
        x += rand / 5_000.to_f

        layer_data << { :x => x, :y => y }
      end


      @tg = TechnicalGraph.new(
        {
          :width => 4000,
          :height => 3000,
        }
      )
      @tg.add_layer(layer_data, layer_params)

      @tg.render
      @tg.image_drawer.save_to_file('samples/test_approximation.png')
    end
  end

end
