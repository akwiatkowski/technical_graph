module AxisLayerDrawModule
  def x_axis_fixed?
     @options[:x_axises_fixed_interval] == true
   end

  # Value axis has fixed count
  def y_axis_fixed?
     @options[:y_axises_fixed_interval] == true
   end

  # Where to put axis values
  def value_axises
    return calc_axis(self.y_min, self.y_max, @options[:y_axises_interval], @options[:y_axises_count], y_axis_fixed?)
  end

  # Where to put axis values
  def parameter_axises
    return calc_axis(self.x_min, self.x_max, @options[:x_axises_interval], @options[:x_axises_count], x_axis_fixed?)
  end

  # Calculate axis using 2 methods
  def calc_axis(from, to, interval, count, fixed_interval)
    axises = Array.new
    l = to - from
    current = from
    
    if fixed_interval
      while current < to
        axises << current
        current += interval
      end
      return axises

    else
      (0...count).each do |i|
        axises << from + (l.to_f * i.to_f) / count.to_f
      end
      return axises

    end
  end


  def calc_bitmap_position(array)
    # TODO move calculatio of lenght here
  end

  def calc_bitmap_x(_x)
    l = self.x_max - self.x_min
    offset = _x - self.x_min
    return (offset.to_f * @image.width.to_f) / l.to_f
  end

  def calc_bitmap_y(_y)
    l = self.y_max - self.y_min
    offset = _y - self.y_min
    return (offset.to_f * @image.width.to_f) / l.to_f
  end

  # Render axis on image
  def render_on_image(image)
    @image = image

    render_values_axis
    render_parameters_axis
  end

  def render_values_axis
    plot_axis_y_line = Magick::Draw.new
    plot_axis_y_text = Magick::Draw.new

    plot_axis_y_line.fill_opacity(0)
    plot_axis_y_line.stroke(@image.options[:axis_color])
    plot_axis_y_line.stroke_opacity(1.0)
    plot_axis_y_line.stroke_width(1.0)
    plot_axis_y_line.stroke_linecap('square')
    plot_axis_y_line.stroke_linejoin('miter')

    plot_axis_y_text.font_family('helvetica')
    plot_axis_y_text.font_style(Magick::NormalStyle)
    plot_axis_y_text.text_align(Magick::LeftAlign)
    plot_axis_y_text.text_undercolor(@image.options[:background_color])

    value_axises.each do |y|
      by = calc_bitmap_y(y)
      plot_axis_y_line.line(
        0, by.round,
        @image.image.columns-1, by.round
      )

      plot_axis_y_text.text(
        5,
        by.round + 15,
        "#{y}"
      )
    end

    t = Time.now
    plot_axis_y_line.draw(@image.image)
    puts "#{Time.now - t} drawing lines"
    plot_axis_y_text.draw(@image.image)
    puts "#{Time.now - t} drawing text"

  end

  def render_parameters_axis

    plot_axis_x_line = Magick::Draw.new
    plot_axis_x_text = Magick::Draw.new

    plot_axis_x_line.fill_opacity(0)
    plot_axis_x_line.stroke(@image.options[:axis_color])
    plot_axis_x_line.stroke_opacity(1.0)
    plot_axis_x_line.stroke_width(1.0)
    plot_axis_x_line.stroke_linecap('square')
    plot_axis_x_line.stroke_linejoin('miter')

    plot_axis_x_text.font_family('helvetica')
    plot_axis_x_text.font_style(Magick::NormalStyle)
    plot_axis_x_text.text_align(Magick::LeftAlign)
    plot_axis_x_text.text_undercolor(@image.options[:background_color])

    parameter_axises.each do |x|
      bx = calc_bitmap_x(x)
      plot_axis_x_line.line(
        bx.round, 0,
        bx.round, @image.image.rows-1
      )

      plot_axis_x_text.text(
        bx.round + 15,
        @image.image.rows - 15,
        "#{x}"
      )
    end

    t = Time.now
    plot_axis_x_line.draw(@image.image)
    puts "#{Time.now - t} drawing lines"
    plot_axis_x_text.draw(@image.image)
    puts "#{Time.now - t} drawing text"

  end

end