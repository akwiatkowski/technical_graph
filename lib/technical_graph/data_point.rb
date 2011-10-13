class DataPoint

  def initialize(h={ :x => 0, :y => 0 })
    @x = h[:x]
    @y = h[:y]
  end

  def self.xy(_x, _y)
    DataPoint.new({ :x=>_x, :y=>_y })
  end

  def x
    @x
  end

  def y
    @y
  end

  def x=(_x)
    @x = _x
  end

  def y=(_y)
    @y = _y
  end


end