require 'helper'

class TestTechnicalMultilayer < Test::Unit::TestCase
  context 'initial options' do
    should 'draw multilayer graph' do
      @tg = TechnicalGraph.new(
        {
          :truncate_string => "%.1f",

          :x_axis_label => 'x',
          :y_axis_label => 'y',

          :axis_antialias => true,
          :layers_antialias => true,
          :font_antialias => true,

          :layers_font_size => 11,
          :axis_font_size => 11,
          :axis_label_font_size => 20,

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

          :legend => true,
          :legend_auto => true,
          :legend_width => 90,
          :legend_margin => 60,
          :legend_x => 50,
          :legend_y => 50,
        }
      )

      max = 50

      # adding simple layer
      layer_params_a = {
        :antialias => true,
        :color => 'red',
        :label => 'first'
      }
      layer_params_b = {
        :antialias => true,
        :color => 'green',
        :label => 'second'
      }
      layer_params_c = {
        :antialias => true,
        :color => 'blue',
        :label => 'third'
      }
      layer_params_d = {
        :antialias => true,
        :color => 'purple',
        :label => 'fourth'
      }
      layer_data_a = Array.new
      layer_data_b = Array.new
      layer_data_c = Array.new
      layer_data_d = Array.new
      (0..max).each do |i|
        layer_data_a << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
        layer_data_b << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(0.3 + i.to_f * (4.0 * 3.14 / max.to_f)) }
        layer_data_c << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(0.6 + i.to_f * (4.0 * 3.14 / max.to_f)) }
        layer_data_d << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(0.9 + i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data_a, layer_params_a)
      @tg.add_layer(layer_data_b, layer_params_b)
      @tg.add_layer(layer_data_c, layer_params_c)
      @tg.add_layer(layer_data_d, layer_params_d)


      @tg.layers.last.raw_data.size.should > 0
      @tg.layers.last.processed_data.size.should > 0
      @tg.layers.size.should == 4

      @tg.render

      @tg.image_drawer.save_to_file("samples/tests/test_multilayer.#{BEST_OUTPUT_FORMAT}")
      @tg.image_drawer.to_format(BEST_OUTPUT_FORMAT).class.should == String

    end
  end

end
