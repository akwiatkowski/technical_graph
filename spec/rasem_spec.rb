require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TechnicalGraph do
  context 'some crazy specs' do
    it 'learning to use rasem' do
      fake_drawer_class = Struct.new('GraphImageDrawerFake', :width, :height)
      fake_drawer = fake_drawer_class.new
      fake_drawer[:width] = 800
      fake_drawer[:height] = 600
      d = GraphImageDrawerRasem.new(fake_drawer)
      d.x_axis([0, 100, 200, 300])
      d.close

      d.save("tmp/rasem_init.svg")
    end

  end
end