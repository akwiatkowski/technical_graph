require 'helper'

class TestTechnicalGraph < Test::Unit::TestCase
  context 'simple rendering' do
    setup do
      @tg = TechnicalGraph.new
    end

    should 'render something' do
      @tg.render
    end
  end


end
