require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'initial options' do
    should 'draw simple graph' do
      @tg = TechnicalGraph.new(
        {
          :truncate_string => "%.1f",

          :x_axis_label => 'x',
          :y_axis_label => 'y',

          #:x_axis_count => 20,
          #:y_axis_count => 20,
          #:x_axis_interval => 1.0,
          #:y_axis_interval => 1.0,
          #:x_axis_fixed_interval => false,
          #:y_axis_fixed_interval => false,

          #:x_min => -10.0,
          #:x_max => 10.0,
          #:y_min => -10.0,
          #:y_max => 10.0,

          #:width => 4000,
          #:height => 3000,
        }
      )

      max = 50

      # adding simple layer
      layer_params = {
        :antialias => true
      }
      layer_data = Array.new
      (0..max).each do |i|
        layer_data << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data, layer_params)
      # should be added
      @tg.layers.last.data.size.should > 0
      # checking ranger for layer

      @tg.render

      @tg.image_drawer.save_to_file('test_simple.png')
      @tg.image_drawer.to_png.class.should == String

    end
  end

end
