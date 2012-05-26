require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TechnicalGraph do
  context 'auto enlarging image dimensions' do

    [10, 20, 123].each_with_index do |min_axis_distance, i|
      it "should make graph bigger (#{i} - #{min_axis_distance})" do
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
            :x_axis_min_distance => min_axis_distance,
            :y_axis_min_distance => min_axis_distance,
          }
        )

        max = 50

        # adding simple layer
        layer_params = {
          :antialias => false,
          :color => '#008844'
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

        @tg.save_to_file("tmp/test_axis_enlarge_#{i}.svg")
        @tg.to_format('svg').class.should == String

        # checking calculated axis
        t = @tg.axis.parameter_axis
        t = t.collect { |x| @tg.axis.image.calc_bitmap_x(x).to_i }

        (1...t.size).each do |i|
          (t[i] - t[i-1]).abs.should >= min_axis_distance
        end

        t = @tg.axis.value_axis
        t = t.collect { |y| @tg.axis.image.calc_bitmap_y(y).to_i }

        (1...t.size).each do |i|
          (t[i] - t[i-1]).abs.should >= min_axis_distance
        end


      end

    end


    it "should not enlarge graph" do
      @tg = TechnicalGraph.new(
        {
          :x_axis_count => 50,
          :y_axis_count => 50,
          #:x_axis_interval => 1.0,
          #:y_axis_interval => 1.0,
          :x_axis_fixed_interval => false,
          :y_axis_fixed_interval => false,

          :width => 200,
          :height => 200,

          :axis_density_enlarge_image => false,
          :x_axis_min_distance => 100,
          :y_axis_min_distance => 100,
        }
      )

      max = 50

      # adding simple layer
      layer_params = {}
      layer_data = Array.new
      (0..max).each do |i|
        layer_data << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data, layer_params)
      # should be added
      @tg.layers.last.raw_data.size.should > 0
      @tg.layers.last.processed_data.size.should > 0
      # checking ranger for layer

      @tg.save_to_file("tmp/test_axis_not_enlarge_1.svg")
      @tg.to_format('svg').class.should == String

      # checking calculated axis
      t = @tg.axis.parameter_axis
      t = t.collect { |x| @tg.axis.image.calc_bitmap_x(x).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should <= 100
      end

      t = @tg.axis.value_axis
      t = t.collect { |y| @tg.axis.image.calc_bitmap_y(y).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should <= 100
      end


    end


    it "should enlarge graph - only X axis" do
      @tg = TechnicalGraph.new(
        {
          :x_axis_count => 50,
          :y_axis_count => 50,
          #:x_axis_interval => 1.0,
          #:y_axis_interval => 1.0,
          :x_axis_fixed_interval => false,
          :y_axis_fixed_interval => false,

          :width => 200,
          :height => 200,

          :x_axis_density_enlarge_image => true,
          :x_axis_min_distance => 100,
          :y_axis_min_distance => 100,
        }
      )

      max = 50

      # adding simple layer
      layer_params = {}
      layer_data = Array.new
      (0..max).each do |i|
        layer_data << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data, layer_params)
      # should be added
      @tg.layers.last.raw_data.size.should > 0
      @tg.layers.last.processed_data.size.should > 0
      # checking ranger for layer

      @tg.save_to_file("tmp/test_axis_x_enlarge.svg")
      @tg.to_format('svg').class.should == String

      # checking calculated axis
      t = @tg.axis.parameter_axis
      t = t.collect { |x| @tg.axis.image.calc_bitmap_x(x).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should >= 100
      end

      t = @tg.axis.value_axis
      t = t.collect { |y| @tg.axis.image.calc_bitmap_y(y).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should <= 100
      end


    end


    it "should enlarge graph - only Y axis" do
      @tg = TechnicalGraph.new(
        {
          :x_axis_count => 50,
          :y_axis_count => 50,
          #:x_axis_interval => 1.0,
          #:y_axis_interval => 1.0,
          :x_axis_fixed_interval => false,
          :y_axis_fixed_interval => false,

          :width => 200,
          :height => 200,

          :y_axis_density_enlarge_image => true,
          :x_axis_min_distance => 100,
          :y_axis_min_distance => 100,
        }
      )

      max = 50

      # adding simple layer
      layer_params = {}
      layer_data = Array.new
      (0..max).each do |i|
        layer_data << { :x => -10.0 + i.to_f, :y => 10.0 * Math.cos(i.to_f * (4.0 * 3.14 / max.to_f)) }
      end
      @tg.add_layer(layer_data, layer_params)
      # should be added
      @tg.layers.last.raw_data.size.should > 0
      @tg.layers.last.processed_data.size.should > 0
      # checking ranger for layer

      @tg.save_to_file("tmp/test_axis_y_enlarge.svg")
      @tg.to_format('svg').class.should == String

      # checking calculated axis
      t = @tg.axis.parameter_axis
      t = t.collect { |x| @tg.axis.image.calc_bitmap_x(x).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should <= 100
      end

      t = @tg.axis.value_axis
      t = t.collect { |y| @tg.axis.image.calc_bitmap_y(y).to_i }

      (1...t.size).each do |i|
        (t[i] - t[i-1]).abs.should >= 100
      end


    end

  end
end
