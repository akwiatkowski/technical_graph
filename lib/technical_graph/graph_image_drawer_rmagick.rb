require 'rubygems'
require 'RMagick'
require 'technical_graph/graph_image_drawer_module'

class GraphImageDrawerRmagick
  include GraphImageDrawerModule

  def initialize(drawer)
    @drawer = self
  end

  attr_reader :drawer

  def crate_blank_graph_image
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


  # Draw both array axis
  def axis(x_array, y_array, options = { :color => 'black', :width => 1 }, render_labels = false, x_labels = [], y_labels = [])
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    plot_axis = axis_draw_object

    x_array.each_with_index do |x, i|
      plot_axis.line(x, 0, x, _s.height)

      # labels
      label = x_labels[i]
      if render_labels and not label.nil?
        label = "#{_s.truncate_string % label}"
        plot_axis.text(x + 15, _s.height - 15, label)
      end
    end

    y_array.each_with_index do |y, i|
      plot_axis.line(0, y, _s.width, y)

      # labels
      label = y_labels[i]
      if render_labels and not label.nil?
        label = "#{_s.truncate_string % label}"
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





  

# TODO refactor it

# Render data layer
  def render_data_layer(l)
    layer_data = l.processed_data

    t = Time.now

    layer_line = Magick::Draw.new
    layer_text = Magick::Draw.new

    # global layer antialias can be override using layer option
    layer_antialias = l.antialias
    layer_antialias = options[:layers_antialias] if layer_antialias.nil?

    layer_line.stroke_antialias(layer_antialias)
    layer_line.fill(l.color)
    layer_line.fill_opacity(1)
    layer_line.stroke(l.color)
    layer_line.stroke_opacity(1.0)
    layer_line.stroke_width(1.0)
    layer_line.stroke_linecap('square')
    layer_line.stroke_linejoin('miter')

    layer_text.text_antialias(font_antialias)
    layer_text.pointsize(options[:layers_font_size])
    layer_text.font_family('helvetica')
    layer_text.font_style(Magick::NormalStyle)
    layer_text.text_align(Magick::LeftAlign)
    layer_text.text_undercolor(options[:background_color])

    # calculate coords, draw text, and then lines and circles
    coords = Array.new

    (0...(layer_data.size - 1)).each do |i|
      ax = layer_data[i].x
      ax = calc_bitmap_x(ax).round
      ay = layer_data[i].y
      ay = calc_bitmap_y(ay).round

      bx = layer_data[i+1].x
      bx = calc_bitmap_x(bx).round
      by = layer_data[i+1].y
      by = calc_bitmap_y(by).round

      coords << {
        :ax => ax, :ay => ay,
        :bx => bx, :by => by,
        :dy => layer_data[i].y
      }
    end

    logger.debug "rendering layer of size #{layer_data.size}, bitmap position calculation"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    # labels
    if l.value_labels
      coords.each do |c|
        string_label = "#{truncate_string % c[:dy]}"
        layer_text.text(
          c[:ax] + 5, c[:ay],
          string_label
        )
      end
      layer_text.draw(@image)
    end

    logger.debug "labels"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    # lines and circles
    coords.each do |c|
      # additional circle
      layer_line.circle(
        c[:ax], c[:ay],
        c[:ax] + 3, c[:ay]
      )
      layer_line.circle(
        c[:bx], c[:by],
        c[:bx] + 3, c[:by]
      )

      # line
      layer_line.line(
        c[:ax], c[:ay],
        c[:bx], c[:by]
      )

      # used for auto positioning of legend
      if legend_auto_position
        @drawn_points << { :x => c[:ax], :y => c[:ay] }
        @drawn_points << { :x => c[:bx], :y => c[:by] }
      end
    end

    logger.debug "dots and lines"
    logger.debug " TIME COST #{Time.now - t}"
    t = Time.now

    layer_line.draw(@image)

    logger.debug "rmagick layer draw"
    logger.debug " TIME COST #{Time.now - t}"
  end

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

# Save output to file
  def save_to_file(file)
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