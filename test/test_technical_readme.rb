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
    end

    should 'create simplest graph' do
      @tg = TechnicalGraph.new
      @tg.add_layer(@simple_data_array)
      @tg.render
      file_name = 'samples/readme/01_simplest.png'
      @tg.image_drawer.save_to_file(file_name)

      # test
      @tg.image_drawer.to_png.class.should == String
      File.exist?(file_name).should == true
    end

    should 'create 2-layer graph' do
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

  end
end
