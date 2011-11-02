require 'helper'

class TestTechnicalReadme < Test::Unit::TestCase
  context 'generate sample graphs using readme options description' do
    setup do
      @simple_data_array = [
        { :x => 0, :y => 0 },
        { :x => 1, :y => 1 },
        { :x => 2, :y => 2 },
        { :x => 3, :y => 2 },
        { :x => 4, :y => 1 },
        { :x => 5, :y => 0 },
      ]
      @simple_data_array_b = [
        { :x => 0.5, :y => 0.5 },
        { :x => 1.5, :y => 0.5 },
        { :x => 2.5, :y => 1.5 },
        { :x => 3.5, :y => 1.0 },
        { :x => 4.5, :y => 1.5 },
        { :x => 5.5, :y => 1.5 },
      ]
      @float_data_array = [
        { :x => 0, :y => 0 },
        { :x => 0.111, :y => 0.123 },
        { :x => 1.222, :y => 1.456 },
        { :x => 1.333, :y => 2.8756 },
        { :x => 2.555, :y => 1.042 },
        { :x => 2.888, :y => 0.988 },
      ]
    end

    #
    should 'create simplest graph' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/01_simplest.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    #
    should 'create 2-layer graph' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new
      @tg.add_layer(@simple_data_array)
      @tg.add_layer(@simple_data_array_b)
      @tg.render
      file_name = 'samples/readme/02_two_layers.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    #
    should 'change ranges' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :x_min => -2,
          :x_max => 10,
          :y_min => -1,
          :y_max => 10,
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/03_changed_ranges.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'change ranges (fixed)' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :x_min => 1,
          :x_max => 2,
          :y_min => 1,
          :y_max => 2,
          :xy_behaviour => :fixed
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/04_changed_ranges_fixed.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'fixed amount of axis' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :x_axis_fixed_interval => false,
          :y_axis_fixed_interval => false,
          :y_axis_count => 20,
          :x_axis_count => 20,
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/05_axis_fixed_amount.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'fixed axis interval' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :x_axis_fixed_interval => true,
          :y_axis_fixed_interval => true,
          :y_axis_interval => 0.8,
          :x_axis_interval => 0.6,
        })
      @tg.axis.x_axis_interval.should == 0.6
      @tg.axis.y_axis_interval.should == 0.8
      @tg.add_layer(@simple_data_array)
      @tg.axis.x_axis_interval.should == 0.6
      @tg.axis.y_axis_interval.should == 0.8

      # axis_x = @tg.axis.calc_axis(@simple_data_array.first[:x], @simple_data_array.last[:x], 0.1, nil, true)
      # axis_y = @tg.axis.calc_axis(@simple_data_array.first[:y], @simple_data_array.last[:y], 0.1, nil, true)
      # puts axis_x.inspect
      # puts axis_y.inspect

      @tg.render
      file_name = 'samples/readme/06_axis_fixed_interval.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'let choose axis label' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :x_axis_label => 'parameter',
          :y_axis_label => 'value',
          :axis_label_font_size => 36
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/07_axis_label.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end


    should 'test truncate string' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :truncate_string => "%.3f"
        })
      @layer_params = {
        :value_labels => true
      }
      @tg.add_layer(@float_data_array, @layer_params)
      @tg.render
      file_name = 'samples/readme/08a_truncate_string.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'test truncate string 2' do
      return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :truncate_string => "%.1f"
        })
      @layer_params = {
        :value_labels => true
      }
      @tg.add_layer(@float_data_array, @layer_params)
      @tg.render
      file_name = 'samples/readme/08b_truncate_string.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'test image size' do
      #return # TODO remove it later, when all tests are done
      @tg = TechnicalGraph.new(
        {
          :width => 600,
          :height => 300
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/09_image_size.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end


  end
end
