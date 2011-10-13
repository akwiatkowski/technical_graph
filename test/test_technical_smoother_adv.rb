require 'helper'

class TestTechnicalSmootherAdv < Test::Unit::TestCase
  context 'using additional X values in smoothing process' do

    should 'create simple X smoothing' do
      tg = TechnicalGraph.new(
        {
          :width => 8000,
          :height => 6000,

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
        x += rand * 1.5

        layer_data << { :x => x, :y => y }
      end

      # adding simple layer
      layer_params = {
        :antialias => false,
        :color => 'red',
        :label => 'raw',
        :value_labels => false,
        :simple_smoother => false,
        :simple_smoother_level => 1,
        :simple_smoother_strategy => :gauss,
        :simple_smoother_x => true
      }
      layer_params_c = layer_params.clone.merge({
        :color => 'green',
        :label => 'processed - level 100',
        :simple_smoother_level => 100,
        :simple_smoother => true
      })
      layer_params_d = layer_params_c.clone.merge({
        :color => 'blue',
        :simple_smoother_x => false
      })

      tg.add_layer(layer_data.clone, layer_params)
      tg.add_layer(layer_data.clone, layer_params_c)
      tg.add_layer(layer_data.clone, layer_params_d)

      tg.render
      tg.image_drawer.save_to_file('samples/tests/test_smoothing_x_values.png')
    end


  end


end
