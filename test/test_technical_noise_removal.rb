require 'helper'

class TestTechnicalNoiseRemoval < Test::Unit::TestCase
  context 'basic noise (wrong data) removal' do

    should 'do linear dry test' do
      layer_data = Array.new
      size = 100
      (0..size).each do |i|
        layer_data << { :x => i.to_f, :y => 5.0 }
      end
      # noise, spike
      layer_data << { :x => 50.1, :y => 12.0 }

      layer_params = {
        :noise_removal => true,
        :noise_removal_level => 3,
        :noise_removal_window_size => 10,
      }

      dl = DataLayer.new(layer_data, layer_params)
      dlp = DataLayerProcessor.new(dl)

      dlp.noise_removal.should == true
      dlp.noise_removal_level.should == 3
      dlp.noise_removal_window_size.should == 10

      # start only noise removal for test
      #dlp.noise_removal_process
      # start everything
      dl.process!

    end
  end

end
