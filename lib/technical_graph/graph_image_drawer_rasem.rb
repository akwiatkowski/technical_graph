#encoding: utf-8

require 'technical_graph/graph_image_drawer_module'
require 'rubygems'
require 'rasem'

class GraphImageDrawerRasem
  include GraphImageDrawerModule

  # Initialize blank image
  def create_blank_image
    @image = Rasem::SVGImage.new(drawer.width, drawer.height)
  end

  # Draw both array axis
  def axis(x_array, y_array, options = { :color => 'black', :width => 1 })
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    _s = self

    @image.group :stroke => options[:color], :stroke_width => options[:width] do
      x_array.each do |x|
        line(x, 0, x, _s.width)
      end

      y_array.each do |y|
        line(0, y, _s.height, y)
      end
    end
  end

  def render_data_layer(l, coords)
    _s = self

    # value labels
    if l.value_labels
      t = Time.now

      @image.group :stroke => _s.options[:axis_color], :stroke_width => 1 do
        coords.each do |c|
          string_label = "#{_s.truncate_string % c[:dy]}"
          text(
            c[:ax] + 5, c[:ay],
            string_label
          )
        end
      end

      logger.debug "labels"
      logger.debug " TIME COST #{Time.now - t}"
    end

    t = Time.now

    # lines and dots
    @image.group :stroke => l.color, :stroke_width => 1 do
      coords.each do |c|
        # additional circle
        circle(c[:ax], c[:ay], 2)
        circle(c[:bx], c[:by], 2)
        # line
        line(
          c[:ax], c[:ay],
          c[:bx], c[:by]
        )

        _s.drawer.post_dot_drawn(c[:ax], c[:ay])
        _s.drawer.post_dot_drawn(c[:bx], c[:by])
      end
    end

    logger.debug "dots and lines"
    logger.debug " TIME COST #{Time.now - t}"
  end

# Needed before saving?
  def close
    @image.close
  end

  def save(file)
    File.open(file, 'w') do |f|
      f << @image.output
    end
  end

end