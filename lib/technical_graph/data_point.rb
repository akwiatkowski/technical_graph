class DataPoint

  def initialize(h={ :x => 0, :y => 0 })
    @x = h[:x]
    @y = h[:y]
  end

  def self.xy(_x, _y)
    DataPoint.new({ :x=>_x, :y=>_y })
  end

  def x_distance(other_dp)
    return (self.x - other_dp.x).abs
  end

  def y_distance(other_dp)
    return (self.y - other_dp.y).abs
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