#encoding: utf-8

require 'technical_graph/graph_image_drawer_module'
require 'rubygems'
require 'chunky_png'
require 'oily_png' if gem_available? 'oily_png'

class GraphImageDrawerChunky
  include GraphImageDrawerModule

  # Initialize blank image
  def create_blank_image
    @image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
  end

  # Draw both array axis
  def axis(x_array, y_array, _options = { :color => 'black', :width => 1 }, render_labels = false, x_labels = [], y_labels = [])
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    x_array.each_with_index do |x, i|
      @image.line(x, 0, x, height, ChunkyPNG::Color.from_hex(_options[:color]))

      # labels
      # chunky_png probably can't write text

      #label = x_labels[i]
      #if render_labels and not label.nil?
      #  label = "#{truncate_string % label}"
      #  plot_axis_text.text(x + 15, height - 15, label)
      #end
    end

    y_array.each_with_index do |y, i|
      @image.line(0, y, width, y, ChunkyPNG::Color.from_hex(_options[:color]))

      # labels
      #label = y_labels[i]
      #if render_labels and not label.nil?
      #  label = "#{truncate_string % label}"
      #  plot_axis_text.text(15, y + 15, label)
      #end
    end

  end

  # Label for parameters and values
  def axis_labels(parameter_label, value_label, _options = { :color => 'black', :width => 1, :size => 20 })
    # chunky_png probably can't write text

    #if options[:x_axis_label].to_s.size > 0
    #  plot = axis_labels_draw_object
    #  plot.stroke(_options[:color])
    #  plot.stroke_width(_options[:width])
    #
    #  plot.text(
    #    (width / 2).to_i,
    #    height - 40,
    #    options[:x_axis_label].to_s
    #  )
    #  plot.draw(@image)
    #end
    #
    #
    #if options[:y_axis_label].to_s.size > 0
    #  plot = axis_labels_draw_object
    #  plot.stroke(_options[:color])
    #  plot.stroke_width(_options[:width])
    #  plot = plot.rotate(90)
    #
    #  plot.text(
    #    (height / 2).to_i,
    #    -40,
    #    options[:y_axis_label].to_s
    #  )
    #  plot.draw(@image)
    #end
  end

  def render_data_layer(l, coords)
    # chunky_png probably can't write text

    ## value labels
    #if l.value_labels
    #  plot = layer_no_stroke(layer_value_labels_draw_object(l))
    #  coords.each do |c|
    #    string_label = "#{truncate_string % c[:dy]}"
    #    plot.text(
    #      c[:ax] + 5, c[:ay],
    #      string_label
    #    )
    #  end
    #  plot.draw(@image)
    #end

    # lines and dots
    coords.each do |c|
      # additional circle
      #plot.circle(c[:ax], c[:ay], c[:ax] + 2, c[:ay])
      #plot.circle(c[:bx], c[:by], c[:bx] + 2, c[:by])

      # line
      @image.line(c[:ax], c[:ay], c[:bx], c[:by], ChunkyPNG::Color.from_hex(l.color))
    end
  end


  def legend(legend_data)
    # chunky_png probably can't write text

    #legend_text_offset = (options[:legend_font_size] / 2.0).round - 4
    #
    #legend_data.each do |l|
    #  plot = axis_draw_object
    #  plot_text = layer_no_stroke(plot)
    #
    #  plot.fill(l[:color])
    #  plot.stroke(l[:color])
    #  plot_text.fill(l[:color])
    #  plot_text.pointsize(options[:legend_font_size])
    #
    #  plot.circle(l[:x], l[:y], l[:x] + 2, l[:y])
    #  plot_text.text(l[:x] + 5, l[:y] + legend_text_offset, l[:label])
    #
    #  plot.draw(@image)
    #  plot_text.draw(@image)
    #end
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

    @image.save(file)

    logger.debug "saving image"
    logger.debug " TIME COST #{Time.now - t}"
  end

  # Export image
  def to_format(format)
    t = Time.now
    blob = @image.to_blob

    logger.debug "exporting image as string"
    logger.debug " TIME COST #{Time.now - t}"

    return blob
  end

end