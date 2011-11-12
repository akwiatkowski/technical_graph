require 'helper'

# run only latest test to create new graphs for documentation
DO_NOT_RUN_OLD_TESTS = true

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
      return if DO_NOT_RUN_OLD_TESTS
      @tg = TechnicalGraph.new
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/01_simplest.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    #
    should 'create 2-layer graph' do
      return if DO_NOT_RUN_OLD_TESTS
      @tg = TechnicalGraph.new
      @tg.add_layer(@simple_data_array)
      @tg.add_layer(@simple_data_array_b)
      @tg.render
      file_name = 'samples/readme/02_two_layers.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    #
    should 'change ranges' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'change ranges (fixed)' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'fixed amount of axis' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'fixed axis interval' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'let choose axis label' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end


    should 'test truncate string' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'test truncate string 2' do
      return if DO_NOT_RUN_OLD_TESTS
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
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'test image size' do
      return if DO_NOT_RUN_OLD_TESTS
      @tg = TechnicalGraph.new(
        {
          :width => 600,
          :height => 300,
          :drawer_class => :rmagick
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/09_image_size.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'test colors' do
      return if DO_NOT_RUN_OLD_TESTS
      @tg = TechnicalGraph.new(
        {
          :background_color => '#000000',
          :background_hatch_color => '#222222',
          :axis_color => '#FFFFFF',
          :drawer_class => :rmagick,
        })
      @tg.add_layer(@simple_data_array, {:color => '#0000FF'})
      @tg.render
      file_name = 'samples/readme/10_colors.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'test renderer' do
      return if DO_NOT_RUN_OLD_TESTS

      @tg = TechnicalGraph.new(
        {
          :drawer_class => :rmagick
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/11_renderer_rmagick.png'
      @tg.image_drawer.save_to_file(file_name)

      @tg = TechnicalGraph.new(
        {
          :drawer_class => :rasem
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/11_renderer_rasem.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    should 'test antialiasing' do
      return if DO_NOT_RUN_OLD_TESTS

      @tg = TechnicalGraph.new(
        {
          :antialias => true,
          :drawer_class => :rmagick
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/12_aa_true.png'
      @tg.image_drawer.save_to_file(file_name)

      # only for size comparison
      @tg = TechnicalGraph.new(
        {
          :antialias => false,
          :drawer_class => :rmagick
        })
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/12_aa_false.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end

    
    should 'test font sizes' do
      return if DO_NOT_RUN_OLD_TESTS

      @tg = TechnicalGraph.new(
        {
          :x_axis_label => 'parameter',
          :y_axis_label => 'value',
          :layers_font_size => 14,
          :axis_font_size => 18,
          :axis_label_font_size => 48
        })
      @tg.add_layer(@simple_data_array, {:value_labels => true})
      @tg.render
      file_name = 'samples/readme/13_font_sizes.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end


    should 'test layer labels, colors and legend' do
      return if DO_NOT_RUN_OLD_TESTS

      @simple_data_array_second = @simple_data_array.collect{|a| {:x => a[:x] + 0.31, :y => a[:y] + 0.21 }}
      @simple_data_array_third = @simple_data_array.collect{|a| {:x => a[:x] * 0.99 + 0.23, :y => a[:y] * 1.2 - 0.12 }}

      @tg = TechnicalGraph.new(
        {
          :legend => true,
          :legend_font_size => 20
        })
      @tg.add_layer(@simple_data_array, {:label => 'simple', :color => '#FFFF00'})
      @tg.add_layer(@simple_data_array_second, {:label => 'offset', :color => '#00FFFF'})
      @tg.add_layer(@simple_data_array_third, {:label => 'scaled', :color => '#FF00FF'})

      @tg.render
      file_name = 'samples/readme/14_simple_legend.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end


    should 'test smoothing' do
      #return if DO_NOT_RUN_OLD_TESTS

      @tg = TechnicalGraph.new(
        {
          :width => 2000,
          :height => 1500,
          :legend => true,
          :x_axis_label => "Parameter",
          :y_axis_label => "Value",
          :drawer_class => :rmagick
        }
      )
      max = 250 #2000

      @layer_data = Array.new
      (0..max).each do |i|
        x = -10.0 + (20.0 * i.to_f / max.to_f)
        y = 10.0 * Math.cos(i.to_f * (2.0 * 3.14 / max.to_f))

        y += rand * 2.0

        @layer_data << { :x => x, :y => y }
      end

      # adding simple layer
      @layer_params = {
        :label => 'raw',
        :value_labels => false,
        :simple_smoother => false,
        :simple_smoother_level => 1,
        :simple_smoother_strategy => :gauss,
        :simple_smoother_x => false,
      }
      @layer_params_b = @layer_params.clone.merge(
        {
          :label => 'smoothed - level 3',
          :simple_smoother_level => 3,
          :simple_smoother => true
        })
      @layer_params_e = @layer_params.clone.merge(
        {
          :label => 'smoothed - level 50',
          :simple_smoother_level => 50,
          :simple_smoother => true
        })

      @tg.add_layer(@layer_data.clone, @layer_params)
      @tg.add_layer(@layer_data.clone, @layer_params_b)
      @tg.add_layer(@layer_data.clone, @layer_params_e)

      @tg.render
      file_name = 'samples/readme/15_smoothing.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_format(@tg.best_output_format).class.should == String
      File.exist?(file_name).should == true
    end


  end
end
