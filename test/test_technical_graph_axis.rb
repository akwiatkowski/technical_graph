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

      @tg.axis.zoomed_x_min.should == -10.0
      @tg.axis.zoomed_x_max.should == 10.0
      @tg.axis.zoomed_y_min.should == -10.0
      @tg.axis.zoomed_y_max.should == 10.0


    end

  end


end

