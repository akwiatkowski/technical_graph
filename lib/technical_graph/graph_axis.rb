#encoding: utf-8

# Calculate axis (only) and draw them

class GraphAxis

  attr_reader :technical_graph

  # Accessor for options Hash
  def options
    @technical_graph.options
  end

  # Accessor for DataLayer Array
  def layers
    @technical_graph.layers
  end

  # Calculate everything
  def data_processor
    @technical_graph.data_processor
  end

  def image_drawer
    @technical_graph.image_drawer
  end

  def truncate_string
    options[:truncate_string]
  end

  def initialize(technical_graph)
    @technical_graph = technical_graph
  end

  def x_axis_fixed?
    options[:x_axis_fixed_interval] == true
  end

  # Value axis has fixed count
  def y_axis_fixed?
    options[:y_axis_fixed_interval] == true
  end

  # Where to put axis values
  def value_axis
    return calc_axis(data_processor.y_min, data_processor.y_max, options[:y_axis_interval], options[:y_axis_count], y_axis_fixed?)
  end

  # Where to put axis values
  def parameter_axis
    return calc_axis(data_processor.x_min, data_processor.x_max, options[:x_axis_interval], options[:x_axis_count], x_axis_fixed?)
  end

  # Calculate axis using 2 methods
  def calc_axis(from, to, interval, count, fixed_interval)
    axis = Array.new
    l = to - from
    current = from

    if fixed_interval
      while current < to
        axis << current
        current += interval
      end
      return axis

    else
      (0...count).each do |i|
        axis << from + (l.to_f * i.to_f) / count.to_f
      end
      return axis

    end
  end


  # Render axis on image
  def render_on_image(image)
    @image = image

    render_values_axis
    render_parameters_axis

    render_values_zero_axis
    render_parameters_zero_axis
  end

  def axis_antialias
    options[:axis_antialias] == true
  end


  def render_values_axis
    plot_axis_y_line = Magick::Draw.new
    plot_axis_y_text = Magick::Draw.new

    plot_axis_y_line.stroke_antialias(axis_antialias)
    plot_axis_y_text.text_antialias(image_drawer.font_antialias)

    plot_axis_y_line.fill_opacity(0)
    plot_axis_y_line.stroke(options[:axis_color])
    plot_axis_y_line.stroke_opacity(1.0)
    plot_axis_y_line.stroke_width(1.0)
    plot_axis_y_line.stroke_linecap('square')
    plot_axis_y_line.stroke_linejoin('miter')

    plot_axis_y_text.font_family('helvetica')
    plot_axis_y_text.font_style(Magick::NormalStyle)
    plot_axis_y_text.text_align(Magick::LeftAlign)
    plot_axis_y_text.text_undercolor(options[:background_color])

    value_axis.each do |y|
      by = image_drawer.calc_bitmap_y(y)
      plot_axis_y_line.line(
        0, by.round,
        @image.columns-1, by.round
      )

      string_label = "#{truncate_string % y}"

      plot_axis_y_text.text(
        5,
        by.round + 15,
        string_label
      )
    end

    t = Time.now
    plot_axis_y_line.draw(@image)
    puts "#{Time.now - t} drawing lines"
    plot_axis_y_text.draw(@image)
    puts "#{Time.now - t} drawing text"
  end

  def render_parameters_axis

    plot_axis_x_line = Magick::Draw.new
    plot_axis_x_text = Magick::Draw.new

    plot_axis_x_line.stroke_antialias(axis_antialias)
    plot_axis_x_text.text_antialias(axis_antialias)

    plot_axis_x_line.fill_opacity(0)
    plot_axis_x_line.stroke(options[:axis_color])
    plot_axis_x_line.stroke_opacity(1.0)
    plot_axis_x_line.stroke_width(1.0)
    plot_axis_x_line.stroke_linecap('square')
    plot_axis_x_line.stroke_linejoin('miter')

    plot_axis_x_text.font_family('helvetica')
    plot_axis_x_text.font_style(Magick::NormalStyle)
    plot_axis_x_text.text_align(Magick::LeftAlign)
    plot_axis_x_text.text_undercolor(options[:background_color])

    parameter_axis.each do |x|
      bx = image_drawer.calc_bitmap_x(x)
      plot_axis_x_line.line(
        bx.round, 0,
        bx.round, @image.rows-1
      )

      string_label = "#{truncate_string % x}"

      plot_axis_x_text.text(
        bx.round + 15,
        @image.rows - 15,
        string_label
      )
    end

    t = Time.now
    plot_axis_x_line.draw(@image)
    puts "#{Time.now - t} drawing lines"
    plot_axis_x_text.draw(@image)
    puts "#{Time.now - t} drawing text"

  end

  # TODO: make it DRY
  def render_values_zero_axis
    plot_axis_y_line = Magick::Draw.new
    plot_axis_y_text = Magick::Draw.new

    plot_axis_y_line.stroke_antialias(axis_antialias)
    plot_axis_y_text.text_antialias(image_drawer.font_antialias)

    plot_axis_y_line.fill_opacity(0)
    plot_axis_y_line.stroke(options[:axis_color])
    plot_axis_y_line.stroke_opacity(1.0)
    plot_axis_y_line.stroke_width(2.0)
    plot_axis_y_line.stroke_linecap('square')
    plot_axis_y_line.stroke_linejoin('miter')

    plot_axis_y_text.font_family('helvetica')
    plot_axis_y_text.font_style(Magick::NormalStyle)
    plot_axis_y_text.text_align(Magick::LeftAlign)
    plot_axis_y_text.text_undercolor(options[:background_color])

    y = 0.0
    by = image_drawer.calc_bitmap_y(y)
    plot_axis_y_line.line(
      0, by.round,
      @image.columns-1, by.round
    )

    plot_axis_y_text.text(
      5,
      by.round + 15,
      "#{y}"
    )

    # TODO: why normal axis does not need it?
    plot_axis_y_line.draw(@image)
    plot_axis_y_text.draw(@image)
  end

  def render_parameters_zero_axis

    plot_axis_x_line = Magick::Draw.new
    plot_axis_x_text = Magick::Draw.new

    plot_axis_x_line.stroke_antialias(axis_antialias)
    plot_axis_x_text.text_antialias(axis_antialias)

    plot_axis_x_line.fill_opacity(0)
    plot_axis_x_line.stroke(options[:axis_color])
    plot_axis_x_line.stroke_opacity(1.0)
    plot_axis_x_line.stroke_width(2.0)
    plot_axis_x_line.stroke_linecap('square')
    plot_axis_x_line.stroke_linejoin('miter')

    plot_axis_x_text.font_family('helvetica')
    plot_axis_x_text.font_style(Magick::NormalStyle)
    plot_axis_x_text.text_align(Magick::LeftAlign)
    plot_axis_x_text.text_undercolor(options[:background_color])

    x = 0.0
    bx = image_drawer.calc_bitmap_x(x)
    plot_axis_x_line.line(
      bx.round, 0,
      bx.round, @image.rows-1
    )

    plot_axis_x_text.text(
      bx.round + 15,
      @image.rows - 15,
      "#{x}"
    )

    # TODO: why normal axis does not need it?
    plot_axis_x_line.draw(@image)
    plot_axis_x_text.draw(@image)
  end

end