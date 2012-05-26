#encoding: utf-8

require 'technical_graph/graph_image_drawer_module'
require 'rubygems'
require 'chunky_png'

#if Gem.source_index.find_name('oily_png').size > 0
#  gem 'oily_png'
#end

class GraphImageDrawerChunky
  include GraphImageDrawerModule

  # Initialize blank image
  def create_blank_image
    @image = ChunkyPNG::Image.new(drawer.width, drawer.heigh, ChunkyPNG::Color::WHITE)
  end

  # Layer used for drawing axis
  def axis_draw_object
    plot_axis = Magick::Draw.new

    plot_axis.stroke_antialias(options[:antialias])
    plot_axis.text_antialias(options[:antialias])
    plot_axis.fill_opacity(1.0)
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

  # Create no-stroke draw object
  def layer_no_stroke(_draw)
    draw = _draw.clone
    draw.stroke_opacity(0.0)
    draw.stroke_width(0.0)
    return draw
  end

  # Create no-fill draw object
  def layer_no_fill(_draw)
    draw = _draw.clone
    draw.fill_opacity(0.0)
    return draw
  end


  # Draw both array axis
  def axis(x_array, y_array, _options = { :color => 'black', :width => 1 }, render_labels = false, x_labels = [], y_labels = [])
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    plot_axis = axis_draw_object
    plot_axis.stroke(_options[:color])
    plot_axis.stroke_width(_options[:width])
    plot_axis_text = layer_no_stroke(plot_axis)
    plot_axis_text.fill(_options[:color])

    x_array.each_with_index do |x, i|
      plot_axis.line(x, 0, x, height)

      # labels
      label = x_labels[i]
      if render_labels and not label.nil?
        label = "#{truncate_string % label}"
        plot_axis_text.text(x + 15, height - 15, label)
      end
    end

    y_array.each_with_index do |y, i|
      plot_axis.line(0, y, width, y)

      # labels
      label = y_labels[i]
      if render_labels and not label.nil?
        label = "#{truncate_string % label}"
        plot_axis_text.text(15, y + 15, label)
      end
    end

    plot_axis.draw(@image)
    plot_axis_text.draw(@image)
  end

  # Label for parameters and values
  def axis_labels(parameter_label, value_label, _options = { :color => 'black', :width => 1, :size => 20 })
    if options[:x_axis_label].to_s.size > 0
      plot = axis_labels_draw_object
      plot.stroke(_options[:color])
      plot.stroke_width(_options[:width])

      plot.text(
        (width / 2).to_i,
        height - 40,
        options[:x_axis_label].to_s
      )
      plot.draw(@image)
    end


    if options[:y_axis_label].to_s.size > 0
      plot = axis_labels_draw_object
      plot.stroke(_options[:color])
      plot.stroke_width(_options[:width])
      plot = plot.rotate(90)

      plot.text(
        (height / 2).to_i,
        -40,
        options[:y_axis_label].to_s
      )
      plot.draw(@image)
    end
  end

  def render_data_layer(l, coords)
    # value labels
    if l.value_labels
      plot = layer_no_stroke(layer_value_labels_draw_object(l))
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
    legend_text_offset = (options[:legend_font_size] / 2.0).round - 4

    legend_data.each do |l|
      plot = axis_draw_object
      plot_text = layer_no_stroke(plot)

      plot.fill(l[:color])
      plot.stroke(l[:color])
      plot_text.fill(l[:color])
      plot_text.pointsize(options[:legend_font_size])

      plot.circle(l[:x], l[:y], l[:x] + 2, l[:y])
      plot_text.text(l[:x] + 5, l[:y] + legend_text_offset, l[:label])

      plot.draw(@image)
      plot_text.draw(@image)
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

end