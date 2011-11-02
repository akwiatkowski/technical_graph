require 'rubygems'
require 'RMagick'

class GraphImageDrawerRmagick

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

end