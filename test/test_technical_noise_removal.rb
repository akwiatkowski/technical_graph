require 'helper'

class TestTechnicalNoiseRemoval < Test::Unit::TestCase
  context 'basic noise (wrong data) removal' do

    should 'do linear dry test' do
      layer_data = Array.new
      (0..5).each do |i|
        layer_data << {:x => i.to_f, :y => i.to_f}
      end
      # noise, spike
      layer_data << { :x => 3.1, :y => 8.0 }

      dl = DataLayer.new(layer_data)
      dlp = DataLayerProcessor.new(dl)

      

      puts dl.processed_data.inspect

    end
  end

end
