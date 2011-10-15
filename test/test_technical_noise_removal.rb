require 'helper'

class TestTechnicalNoiseRemoval < Test::Unit::TestCase
  context 'basic noise (wrong data) removal' do

    should 'dry test' do
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


end
