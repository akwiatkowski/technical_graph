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

  # Return binary PNG
  def to_png
    to_format('png')
  end

  def to_svg
    to_format('svg')
  end

  def to_svgz
    drawer.deflate_string( to_format('svg') )
  end

  def deflate_string(str, level = 9)
    z = Zlib::Deflate.new(level)
    dst = z.deflate(str, Zlib::FINISH)
    z.close
    dst
  end

  def format_from_filename(file)
    file.gsub(/^.*\./, '')
  end

  # Used for creating temp files
  def random_filename
    (0...16).map{65.+(rand(25)).chr}.join
  end

end