require 'rubygems'
require 'RMagick'
require 'technical_graph/graph_image_drawer_module'

class GraphImageDrawerRmagick
  include GraphImageDrawerModule

  def create_blank_image
    @image = Magick::ImageList.new
    @image.new_image(
      width,
      height,
      Magick::HatchFill.new(
        options[:background_color],
        options[:background_hatch_color]
      )
    )

    return @image
  end

  # Layer used for drawing axis
  def axis_draw_object
    plot_axis = Magick::Draw.new

    plot_axis.stroke_antialias(options[:antialias])
    plot_axis.text_antialias(options[:antialias])
    plot_axis.fill_opacity(0)
    plot_axis.stroke(options[:axis_color])
    plot_axis.stroke_opacity(1.0)
    plot_axis.stroke_width(1.0)
    plot_axis.stroke_linecap('square')
    plot_axis.stroke_linejoin('miter')

    plot_axis.pointsize(options[:axis_font_size])
    plot_axis.font_family('helvetica')
    plot_axis.font_style(Magick::NormalStyle)
    plot_axis.text_align(Magick::LeftAlign)
    plot_axis.text_undercolor(options[:background_color])

    return plot_axis
  end

  # Layer used for drawing main labels (parameter, value)
  def axis_labels_draw_object
    draw = axis_draw_object
    draw.pointsize(options[:axis_label_font_size])
    draw.font_style(Magick::NormalStyle)
    draw.text_align(Magick::CenterAlign)

    return draw
  end

  # Layer used for drawing value labels
  def layer_value_labels_draw_object(layer)
    draw = axis_draw_object
    draw.pointsize(options[:layers_font_size])
    return draw
  end

  # Layer used for drawing chart, lines and dots
  def layer_draw_object(layer)
    draw = axis_draw_object
    draw.fill(layer.color)
    draw.stroke(layer.color)
    return draw
  end


  # Draw both array axis
  def axis(x_array, y_array, options = { :color => 'black', :width => 1 }, render_labels = false, x_labels = [], y_labels = [])
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    plot_axis = axis_draw_object

    x_array.each_with_index do |x, i|
      plot_axis.line(x, 0, x, height)

      # labels
      label = x_labels[i]
      if render_labels and not label.nil?
        label = "#{truncate_string % label}"
        plot_axis.text(x + 15, height - 15, label)
      end
    end

    y_array.each_with_index do |y, i|
      plot_axis.line(0, y, width, y)

      # labels
      label = y_labels[i]
      if render_labels and not label.nil?
        label = "#{truncate_string % label}"
        plot_axis.text(15, y + 15, label)
      end
    end

    plot_axis.draw(@image)
  end

  # Label for parameters and values
  def axis_labels(parameter_label, value_label, options = { :color => 'black', :width => 1, :size => 20 })
    if options[:x_axis_label].to_s.size > 0
      plot = axis_labels_draw_object

      plot.text(
        (width / 2).to_i,
        height - 40,
        options[:x_axis_label].to_s
      )
      plot.draw(@image)
    end


    if options[:y_axis_label].to_s.size > 0
      plot = axis_labels_draw_object
      plot = plot_axis_text.rotate(90)

      plot.text(
        (height / 2).to_i,
        40,
        options[:y_axis_label].to_s
      )
      plot.draw(@image)
    end
  end

  def render_data_layer(l, coords)
    # value labels
    if l.value_labels
      plot = layer_value_labels_draw_object(l)
      coords.each do |c|
        string_label = "#{truncate_string % c[:dy]}"
        plot.text(
          c[:ax] + 5, c[:ay],
          string_label
        )
      end
      plot.draw(@image)
    end

    # lines and dots
    plot = layer_draw_object(l)
    coords.each do |c|
      # additional circle
      plot.circle(c[:ax], c[:ay], c[:ax] + 2, c[:ay])
      plot.circle(c[:bx], c[:by], c[:bx] + 2, c[:by])

      # line
      plot.line(
        c[:ax], c[:ay],
        c[:bx], c[:by]
      )

      drawer.post_dot_drawn(c[:ax], c[:ay])
      drawer.post_dot_drawn(c[:bx], c[:by])
    end
    plot.draw(@image)
  end


  def legend(legend_data)
    legend_data.each do |l|
      plot = axis_draw_object
      plot.fill(l[:color])
      plot.stroke(l[:color])

      plot.circle(l[:x], l[:y], l[:x] + 2, l[:y])
      plot.text(l[:x] + 5, l[:y], l[:label])

      plot.draw(@image)
    end
  end

  def close
    # only for compatibility
    @closed = true
  end

  def closed?
    @closed
  end

  # Save output to file
  def save(file)
    t = Time.now

    @image.write(file)

    logger.debug "saving image"
    logger.debug " TIME COST #{Time.now - t}"
  end

  # Export image
  def to_format(format)
    t = Time.now
    i = @image.flatten_images
    i.format = format
    blob = i.to_blob

    logger.debug "exporting image as string"
    logger.debug " TIME COST #{Time.now - t}"

    return blob
  end


# TODO refactor it


# Render legend on graph
  def render_data_legend
    return unless draw_legend?

    recalculate_legend_position

    t = Time.now

    legend_text = Magick::Draw.new
    legend_text_antialias = options[:layers_font_size]
    legend_text.stroke_antialias(legend_text_antialias)
    legend_text.text_antialias(legend_text_antialias)
    legend_text.pointsize(options[:axis_font_size])
    legend_text.font_family('helvetica')
    legend_text.font_style(Magick::NormalStyle)
    legend_text.text_align(Magick::LeftAlign)
    legend_text.text_undercolor(options[:background_color])

    x = legend_x
    y = legend_y

    layers.each do |l|
      legend_text.fill(l.color)

      string_label = l.label
      legend_text.text(
        x, y,
        string_label
      )

      # little dot
      legend_text.circle(
        x - 10, y,
        x - 10 + 3, y
      )

      y += ONE_LAYER_LEGEND_HEIGHT
    end

    logger.debug "auto legend creating image layer"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    legend_text.draw(@image)

    logger.debug "auto legend drawing image layer"
    logger.debug " TIME COST #{Time.now - t}"
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


end