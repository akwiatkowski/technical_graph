require 'helper'

class TestTechnicalRasem < Test::Unit::TestCase
  context 'drawing SVG graphs using rasem' do

    should 'do some initials' do
      fake_drawer_class = Struct.new('GraphImageDrawerFake', :width, :height)
      fake_drawer = fake_drawer_class.new
      fake_drawer[:width] = 800
      fake_drawer[:height] = 600
      d = GraphImageDrawerRasem.new(fake_drawer)
      d.x_axis([ 0, 100, 200, 300 ])
      d.close
      
      d.save("samples/tests/rasem_init.svg")
    end


  end


end
