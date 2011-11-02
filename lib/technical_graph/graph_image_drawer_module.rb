#encoding: utf-8

module GraphImageDrawerModule

  def initialize(drawer)
    @drawer = drawer
    create_blank_image
  end

  attr_reader :drawer

  def width
    drawer.width
  end

  def height
    drawer.height
  end

  def truncate_string
    drawer.truncate_string
  end

  def options
    drawer.options
  end

  def logger
    drawer.logger
  end



  # Draw one or many axis
  def x_axis(x_array, options = { :color => 'black', :width => 1 })
    axis(x_array, [], options)
  end

  # Draw one or many axis
  def y_axis(y_array, options = { :color => 'black', :width => 1 })
    axis([], y_array, options)
  end

end