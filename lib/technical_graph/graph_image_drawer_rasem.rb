#encoding: utf-8

require 'rubygems'
require 'rasem'

class GraphImageDrawerRasem

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

  # Move to common module everything above


  # Initialize blank image
  def create_blank_image
    @image = Rasem::SVGImage.new(drawer.width, drawer.height)
  end

  # Draw one or many axis
  def x_axis(x_array, options = { :color => 'black', :width => 1 })
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    w = width

    @image.group :stroke => options[:color], :stroke_width => options[:width] do
      x_array.each do |x|
        #line(x, 0, x, self.width)
        line(x, 0, x, w)
      end
    end
  end

  def close
    @image.close
  end

  def save(file)
    File.open(file, 'w') do |f|
      f << @image.output
    end
  end

  def line(ax, ay, bx, by, options = { :color => 'black', :width => 1 })
    #@image.line
  end

end