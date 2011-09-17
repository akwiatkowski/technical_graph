require 'helper'

class TestTechnicalGraphAxis < Test::Unit::TestCase
  context 'ranges calculation' do
    setup do
    end

    should 'provide defined ranges' do
      x_min = 0.0
      x_max = 10.0
      y_min = -5.0
      y_max = 5.0

      @tg = TechnicalGraph.new(
        {
          :x_min => x_min,
          :x_max => x_max,
          :y_min => y_min,
          :y_max => y_max,
          :xy_behaviour => :fixed
        }
      )
      @tg.render

      @tg.axis.x_min.should == x_min
      @tg.axis.x_max.should == x_max
      @tg.axis.y_min.should == y_min
      @tg.axis.y_max.should == y_max
    end

    should 'calculate ranges per layer' do
      # adding simple layer
      layer_data = [
        { :x => -1, :y => 3.0 },
        { :x => 3, :y => -8.0 },
        { :x => 0, :y => 3.0 },
        { :x => 10, :y => 10.0 }
      ]
      dl = DataLayer.new(layer_data)

      dl.x_min.should == -1
      dl.x_max.should == 10
      dl.y_min.should == -8.0
      dl.y_max.should == 10.0
    end


    should 'provide ranges calculated using data layer, and multiple layers' do
      x_min = 0.0
      x_max = 1.0
      y_min = -1.0
      y_max = 1.0

      @tg = TechnicalGraph.new(
        {
          :x_min => x_min,
          :x_max => x_max,
          :y_min => y_min,
          :y_max => y_max,
          :xy_behaviour => :default
        }
      )

      # adding simple layer
      layer_data = [
        { :x => -1, :y => 3.0 },
        { :x => 3, :y => -8.0 },
        { :x => 0, :y => 3.0 },
        { :x => 10, :y => 10.0 }
      ]
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render


      @tg.axis.x_min.should_not == x_min
      @tg.axis.x_max.should_not == x_max
      @tg.axis.y_min.should_not == y_min
      @tg.axis.y_max.should_not == y_max

      @tg.axis.x_min.should == -1
      @tg.axis.x_max.should == 10
      @tg.axis.y_min.should == -8.0
      @tg.axis.y_max.should == 10.0



      # adding another layer

      # adding simple layer
      layer_data = [
        { :x => -21, :y => -93.0 },
        { :x => -5, :y => 3.0 },
        { :x => 39, :y => -8.0 },
        { :x => 0, :y => 333.0 },
        { :x => 10, :y => 50.0 }
      ]
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 1

      @tg.render

      @tg.axis.x_min.should_not == x_min
      @tg.axis.x_max.should_not == x_max
      @tg.axis.y_min.should_not == y_min
      @tg.axis.y_max.should_not == y_max

      @tg.axis.x_min.should_not == -1.0
      @tg.axis.x_max.should_not == 10.0
      @tg.axis.y_min.should_not == -8.0
      @tg.axis.y_max.should_not == 10.0

      @tg.axis.x_min.should == -21.0
      @tg.axis.x_max.should == 39.0
      @tg.axis.y_min.should == -93.0
      @tg.axis.y_max.should == 333.0
    end

    should 'provide ranges calculated with zoom' do
      x_min = 0.0
      x_max = 1.0
      y_min = -1.0
      y_max = 1.0

      @tg = TechnicalGraph.new(
        {
          :x_min => x_min,
          :x_max => x_max,
          :y_min => y_min,
          :y_max => y_max,
          :xy_behaviour => :default
        }
      )

      # adding simple layer
      layer_data = [
        { :x => -5, :y => 5.0 },
        { :x => 2, :y => -5.0 },
        { :x => 0, :y => 5.0 },
        { :x => 5, :y => 5.0 }
      ]
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render


      @tg.axis.x_min.should_not == x_min
      @tg.axis.x_max.should_not == x_max
      @tg.axis.y_min.should_not == y_min
      @tg.axis.y_max.should_not == y_max

      @tg.axis.x_min.should == -5
      @tg.axis.x_max.should == 5
      @tg.axis.y_min.should == -5.0
      @tg.axis.y_max.should == 5.0

      @tg.axis.zoom = 2.0

      @tg.axis.x_min.should == -10.0
      @tg.axis.x_max.should == 10.0
      @tg.axis.y_min.should == -10.0
      @tg.axis.y_max.should == 10.0

      @tg.axis.x_min.should_not == -5
      @tg.axis.x_max.should_not == 5
      @tg.axis.y_min.should_not == -5.0
      @tg.axis.y_max.should_not == 5.0

      @tg.axis.raw_x_min.should == -5
      @tg.axis.raw_x_max.should == 5
      @tg.axis.raw_y_min.should == -5.0
      @tg.axis.raw_y_max.should == 5.0
    end


    should 'calculate axis with fixed interval' do
      x_min = -5.0
      x_max = 5.0
      y_min = -5.0
      y_max = 5.0

      @tg = TechnicalGraph.new(
        {
          :x_min => x_min,
          :x_max => x_max,
          :y_min => y_min,
          :y_max => y_max,
          :xy_behaviour => :fixed,

          :y_axises_count => 10,
          :x_axises_count => 10,
          :y_axises_interval => 1.0,
          :x_axises_interval => 4.0,
          :x_axises_fixed_interval => true,
          :y_axises_fixed_interval => true
        }
      )

      # adding simple layer
      layer_data = [
        { :x => -1, :y => 2.0 },
        { :x => 1, :y => -2.0 },
        { :x => 0, :y => 2.0 },
        { :x => 1, :y => 2.0 }
      ]
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render

      @tg.axis.value_axises.should == [-5.0, -4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0]
      @tg.axis.parameter_axises.should == [-5.0, -1.0, 3.0]
    end


    should 'calculate axis with fixed count' do
      x_min = -8.0
      x_max = 8.0
      y_min = -4.0
      y_max = 4.0

      @tg = TechnicalGraph.new(
        {
          :x_min => x_min,
          :x_max => x_max,
          :y_min => y_min,
          :y_max => y_max,
          :xy_behaviour => :fixed,

          :x_axises_count => 8,
          :y_axises_count => 4,
          :x_axises_interval => 2.0,
          :y_axises_interval => 1.0,
          :x_axises_fixed_interval => false,
          :y_axises_fixed_interval => false
        }
      )

      # adding simple layer
      layer_data = [
        { :x => -1, :y => 2.0 },
        { :x => 1, :y => -2.0 },
        { :x => 0, :y => 2.0 },
        { :x => 1, :y => 2.0 }
      ]
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render

      @tg.axis.parameter_axises.should == [-8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0]
      @tg.axis.value_axises.should == [-4.0, -2.0, 0.0, 2.0]

      @tg.image.save_to_file('test1.png')
    end


    should 'draw simple graph' do
      @tg = TechnicalGraph.new(
        {
          :x_axises_count => 10,
          :y_axises_count => 10,
          :x_axises_interval => 1.0,
          :y_axises_interval => 1.0,
          :x_axises_fixed_interval => false,
          :y_axises_fixed_interval => false,

          :x_min => -10.0,
          :x_max => 10.0,
          :y_min => -10.0,
          :y_max => 10.0
        }
      )



      # adding simple layer
      layer_data = Array.new
      (0..20).each do |i|
        layer_data << {:x => Math.sin(i.to_f/10.0) * 10.0, :y => Math.cos(i.to_f/10.0) * 10.0 }
      end
      @tg.add_layer(layer_data)
      # should be added
      @tg.layers.last.data.size > 0
      # checking ranger for layer

      @tg.render

      @tg.image.save_to_file('test2.png')
    end

  end

end

