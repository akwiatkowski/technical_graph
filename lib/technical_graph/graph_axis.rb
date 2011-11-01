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

  def logger
    @technical_graph.logger
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

  def y_axis_interval
    options[:y_axis_interval]
  end

  def x_axis_interval
    options[:x_axis_interval]
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
    t = Time.now

    axis = Array.new
    l = to - from
    current = from

    if fixed_interval
      while current < to
        axis << current
        current += interval
      end
      logger.debug "fixed interval axis calculation from #{from} to #{to} using int. #{interval}"
      logger.debug " TIME COST #{Time.now - t}"
      return axis

    else
      (0...count).each do |i|
        axis << from + (l.to_f * i.to_f) / count.to_f
      end
      logger.debug "fixed count axis calculation from #{from} to #{to} using count #{count}"
      logger.debug " TIME COST #{Time.now - t}"
      return axis

    end
  end

  # Enlarge image to maintain proper axis density
  def axis_distance_image_enlarge
    if options[:axis_density_enlarge_image]
      t = Time.now
      x_axis_distance_image_enlarge
      y_axis_distance_image_enlarge

      logger.debug "axis enlarged"
      logger.debug " TIME COST #{Time.now - t}"
    end
  end

  # Enlarge image to maintain proper axis density
  def x_axis_distance_image_enlarge
    a = parameter_axis
    # must be at least 2 axis
    return if a.size < 2

    ax = a[0]
    ax = image_drawer.calc_bitmap_y(ax).round
    bx = a[1]
    bx = image_drawer.calc_bitmap_y(bx).round

    axis_distance = (bx - ax).abs

    if axis_distance < options[:x_axis_min_distance]
      # enlarging image
      options[:old_width] = options[:width]
      options[:width] *= (options[:x_axis_min_distance] / axis_distance).ceil
    end
  end

  # Enlarge image to maintain proper axis density
  def y_axis_distance_image_enlarge
    a = value_axis
    # must be at least 2 axis
    return if a.size < 2

    ay = a[0]
    ay = image_drawer.calc_bitmap_y(ay).round
    by = a[1]
    by = image_drawer.calc_bitmap_y(by).round

    axis_distance = (by - ay).abs

    if axis_distance < options[:y_axis_min_distance]
      # enlarging image
      options[:old_height] = options[:height]
      options[:height] *= (options[:y_axis_min_distance] / axis_distance).ceil
    end
  end

  # Render axis on image
  def render_on_image(image)
    @image = image

    render_values_axis
    render_parameters_axis

    render_values_zero_axis
    render_parameters_zero_axis

    render_axis_labels
  end

  def axis_antialias
    options[:axis_antialias] == true
  end


  def render_values_axis
    t = Time.now

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

    plot_axis_y_text.pointsize(options[:axis_font_size])
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

    logger.debug "render values axis layer"
    logger.debug " TIME COST #{Time.now - t}"

    t = Time.now
    plot_axis_y_line.draw(@image)
    logger.debug "render values axis drawing lines"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now
    plot_axis_y_text.draw(@image)
    logger.debug "render values axis drawing text"
    logger.debug " TIME COST #{Time.now - t}"
  end

  def render_parameters_axis
    t = Time.now

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

    plot_axis_x_text.pointsize(options[:axis_font_size])
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
        bx.round + 5,
        @image.rows - 15,
        string_label
      )
    end

    logger.debug "render parameters axis layer"
    logger.debug " TIME COST #{Time.now - t}"

    t = Time.now
    plot_axis_x_line.draw(@image)
    logger.debug "render parameters axis drawing lines"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now
    plot_axis_x_text.draw(@image)
    logger.debug "render parameters axis drawing text"
    logger.debug " TIME COST #{Time.now - t}"

  end

  # TODO: make it DRY
  def render_values_zero_axis
    t = Time.now

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

    plot_axis_y_text.pointsize(options[:axis_font_size])
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

    logger.debug "render 0-value axis layer"
    logger.debug " TIME COST #{Time.now - t}"

    # TODO: why normal axis does not need it?
    t = Time.now
    plot_axis_y_line.draw(@image)
    logger.debug "render 0-value axis drawing line"
    logger.debug " TIME COST #{Time.now - t}"

    t = Time.now
    plot_axis_y_text.draw(@image)
    logger.debug "render 0-value axis drawing text"
    logger.debug " TIME COST #{Time.now - t}"
  end

  def render_parameters_zero_axis
    t = Time.now

    plot_axis_x_line = Magick::Draw.new
    plot_axis_x_text = Magick::Draw.new

    plot_axis_x_line.stroke_antialias(axis_antialias)
    plot_axis_x_text.text_antialias(image_drawer.font_antialias)

    plot_axis_x_line.fill_opacity(0)
    plot_axis_x_line.stroke(options[:axis_color])
    plot_axis_x_line.stroke_opacity(1.0)
    plot_axis_x_line.stroke_width(2.0)
    plot_axis_x_line.stroke_linecap('square')
    plot_axis_x_line.stroke_linejoin('miter')

    plot_axis_x_text.pointsize(options[:axis_font_size])
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

    logger.debug "render 0-parameter axis layer"
    logger.debug " TIME COST #{Time.now - t}"

    # TODO: why normal axis does not need it?
    t = Time.now
    plot_axis_x_line.draw(@image)
    logger.debug "render 0-parameter axis drawing line"
    logger.debug " TIME COST #{Time.now - t}"

    t = Time.now
    plot_axis_x_text.draw(@image)
    logger.debug "render 0-parameter axis drawing text"
    logger.debug " TIME COST #{Time.now - t}"
  end

  def render_axis_labels
    if options[:x_axis_label].to_s.size > 0
      t = Time.now

      plot_axis_text = Magick::Draw.new
      plot_axis_text.text_antialias(image_drawer.font_antialias)

      plot_axis_text.pointsize(options[:axis_label_font_size])
      plot_axis_text.font_family('helvetica')
      plot_axis_text.font_style(Magick::NormalStyle)
      #plot_axis_text.text_align(Magick::LeftAlign)
      plot_axis_text.text_align(Magick::CenterAlign)
      plot_axis_text.text_undercolor(options[:background_color])

      plot_axis_text.text(
        (@image.columns / 2).to_i,
        @image.rows - 40,
        options[:x_axis_label].to_s
      )
      logger.debug "render parameter axis label layer"
      logger.debug " TIME COST #{Time.now - t}"

      t = Time.now
      plot_axis_text.draw(@image)
      logger.debug "render drawing parameter axis label"
      logger.debug " TIME COST #{Time.now - t}"
    end

    if options[:y_axis_label].to_s.size > 0
      t = Time.now

      plot_axis_text = Magick::Draw.new
      plot_axis_text.text_antialias(image_drawer.font_antialias)

      plot_axis_text.pointsize(options[:axis_label_font_size])
      plot_axis_text.font_family('helvetica')
      plot_axis_text.font_style(Magick::NormalStyle)
      #plot_axis_text.text_align(Magick::LeftAlign)
      plot_axis_text.text_align(Magick::CenterAlign)
      plot_axis_text.text_undercolor(options[:background_color])

      plot_axis_text = plot_axis_text.rotate(90)
      plot_axis_text.text(
        (@image.rows / 2).to_i,
        -40,
        options[:y_axis_label].to_s
      )
      logger.debug "render value axis label layer"
      logger.debug " TIME COST #{Time.now - t}"

      t = Time.now
      plot_axis_text.draw(@image)
      logger.debug "render drawing value axis label"
      logger.debug " TIME COST #{Time.now - t}"
    end
  end

end