require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TechnicalGraph do
  context 'y_min = y_max' do
    it 'draw graph without error - NaN' do

      @tg = TechnicalGraph.new(
        {
          # code from HomeIO
          :x_axis_label => 'label',
          :y_axis_label => 'value',

          :x_axis_interval => 1.0,
          :y_axis_count => 10,
          :x_axis_fixed_interval => true,
          :y_axis_fixed_interval => false,
          :width => 800,
          :height => 600,

          :axis_antialias => false,
          :layers_font_size => 10,
          :axis_font_size => 10,
          :axis_label_font_size => 24,

          :x_min => -10.0,
          :x_max => 40.0,
          :y_max => 10.0,
          :y_min => 10.0
        }
      )

      max = 50
      layer_data_a = Array.new
      (0..max).each do |i|
        layer_data_a << { :x => -10.0 + i.to_f, :y => 10.0 }
      end
      @tg.add_layer(layer_data_a)

      @tg.to_format('svg').class.should == String

    end

    it 'draw graph without another error' do
      @tg = TechnicalGraph.new(
        {
          :x_min => -10.0,
          :x_max => 40.0,
          :y_max => 10.0,
          :y_min => 10.0
        }
      )

      max = 50
      layer_data_a = Array.new
      (0..max).each do |i|
        layer_data_a << { :x => -10.0 + i.to_f, :y => 10.0 }
      end
      @tg.add_layer(layer_data_a)

      @tg.to_format('svg').class.should == String

    end
  end

end
