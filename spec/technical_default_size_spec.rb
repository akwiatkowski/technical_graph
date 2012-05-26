require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TechnicalGraph do
  context 'setting default graph size' do
    it 'should set lower default size' do
      GraphImageDrawer.width = 400
      GraphImageDrawer.width.should == 400

      GraphImageDrawer.height = 300
      GraphImageDrawer.height.should == 300
    end

  end
end
