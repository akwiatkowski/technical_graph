require 'helper'

class TestTechnicalAxisEnlarge < Test::Unit::TestCase
  context 'initial options' do
    should 'enlarge image' do
      @tg = TechnicalGraph.new(
        {
          :truncate_string => "%.1f",

          :x_axis_label => 'x',
          :y_axis_label => 'y',

          :axis_antialias => true,
          :layers_antialias => true,
          :font_antialias => true,

          :layers_font_size => 8,
          :axis_font_size => 8,
          :axis_label_font_size => 20,

          :x_axis_count => 50,
          :y_axis_count => 50,
          #:x_axis_interval => 1.0,
          #:y_axis_interval => 1.0,
          :x_axis_fixed_interval => false,
          :y_axis_fixed_interval => false,

          #:x_min => -10.0,
          #:x_max => 10.0,
          #:y_min => -10.0,
          #:y_max => 10.0,

          :width => 800,
          :height => 600,

          :axis_density_enlarge_image => true,
          :x_axis_min_distance => 50,
          :y_axis_min_distance => 50,
        }
      )

      max = 50

      # adding simple layer
      layer_params = {
        :antialias => false,
        #:color => 'red'
        :color => '#FFFF00'
      }
      layer_data = Array.new
      (0..max).each do |i|
        layer_data << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data, layer_params)
      # should be added
      @tg.layers.last.raw_data.size.should > 0
      @tg.layers.last.processed_data.size.should > 0
      # checking ranger for layer

      @tg.render

      @tg.image_drawer.save_to_file("samples/tests/test_axis_enlarge.#{@tg.best_output_format}")
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String

    end
  end

end
