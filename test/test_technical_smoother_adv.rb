require 'helper'

class TestTechnicalSmootherAdv < Test::Unit::TestCase
  context 'using additional X values in smoothing process' do

    should 'calculate proper values' do
      max = 2000

      layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (2.0 * 3.14 / max.to_f))

        y += rand * 4.0
        x += rand * 1.5

        layer_data << { :x => x, :y => y }
      end
      dl = DataLayer.new(layer_data)
      dlp = DataLayerProcessor.new(dl)

      level = 50

      dlp.simple_smoother_strategy = :gauss
      dlp.simple_smoother_level = level
      dlp.simple_smoother_x = true
      dlp.generate_vector

      test_array = Array.new
      x = 0.0
      y = 2.0
      level.times do
        dp = DataPoint.xy(x, y + rand)
        x += 1.0
        test_array << dp
      end
      current_position = (test_array.size / 2.0).floor
      current_position_point = test_array[current_position]

      processed_yx = dlp.process_part_only_x(test_array, current_position_point)
      processed_x = dlp.process_part_only_y(test_array)

      puts processed_x.inspect
      puts processed_yx.inspect


    end


    should 'create simple X smoothing' do
      #return # TODO

      tg = TechnicalGraph.new(
        {
          :width => 2000, #8000,
          :height => 1500, #6000,

          :legend => true,
          :legend_auto => true,
          :legend_width => 90,
          :legend_margin => 60,
          :legend_x => 50,
          :legend_y => 50,

          :log_level => Logger::DEBUG,

          :x_axis_label => "Parameter",
          :y_axis_label => "Value",
          :axis_label_font_size => 28
        }
      )
      max = 50 #2000

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
        #:perform_parameter_uniq => true,
        :antialias => false,
        :color => 'red',
        :label => 'raw',
        :value_labels => false,
        :simple_smoother => false,
        :simple_smoother_level => 1,
        :simple_smoother_strategy => :gauss,
        :simple_smoother_x => false
      }
      layer_params_c = layer_params.clone.merge(
        {
          :color => 'green',
          :label => 'processed - level 100',
          :simple_smoother_level => 100,
          :simple_smoother => true
        })
      layer_params_d = layer_params_c.clone.merge(
        {
          :color => 'blue',
          :simple_smoother_x => true
        })

      tg.add_layer(layer_data.clone, layer_params)
      tg.add_layer(layer_data.clone, layer_params_c)
      tg.add_layer(layer_data.clone, layer_params_d)

      tg.render
      #tg.image_drawer.save_to_file('samples/tests/test_smoothing_x_values.png')
      tg.image_drawer.save_to_file('samples/tests/test_smoothing_x_values.svg')
    end


  end


end
