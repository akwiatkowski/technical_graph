require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'initial options' do
    should 'draw simple graph' do
      @tg = TechnicalGraph.new(
        {
          :x_axises_count => 10,
          :y_axises_count => 10,
          :x_axises_interval => 1.0,
          :y_axises_interval => 1.0,
          :x_axises_fixed_interval => false,
          :y_axises_fixed_interval => false,

          :x_min => -10.0,
          :x_max => 10.0,
          :y_min => -10.0,
          :y_max => 10.0
        }
      )


      # adding simple layer
      layer_data = Array.new
      (0..20).each do |i|
        layer_data << { :x => Math.sin(i.to_f/10.0) * 10.0, :y => Math.cos(i.to_f/10.0) * 10.0 }
      end
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render

      @tg.image_drawer.save_to_file('test2.png')
    end
  end

end
