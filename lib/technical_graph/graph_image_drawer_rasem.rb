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
  def axis(x_array, y_array, options = { :color => 'black', :width => 1 }, render_labels = false, x_labels = [], y_labels = [])
    # for single axis
    x_array = [x_array] if not x_array.kind_of? Array
    y_array = [y_array] if not y_array.kind_of? Array

    _s = self

    @image.group :stroke => options[:color], :stroke_width => options[:width] do
      x_array.each_with_index do |x, i|
        line(x, 0, x, _s.height, { })

        # labels
        label = x_labels[i]
        if render_labels and not label.nil?
          label = "#{_s.truncate_string % label}"
          text(x + 15, _s.height - 15, label, { })
        end
      end

      y_array.each_with_index do |y, i|
        line(0, y, _s.width, y, { })

        # labels
        label = y_labels[i]
        if render_labels and not label.nil?
          label = "#{_s.truncate_string % label}"
          text(15, y + 15, label, { })
        end
      end
    end
  end

  # Label for parameters and values
  def axis_labels(parameter_label, value_label, options = { :color => 'black', :width => 1, :size => 20 })
    _s = self
    @image.group :stroke => options[:color], :stroke_width => options[:width] do
      text(
        (_s.width / 2).to_i,
        _s.height - 40,
        parameter_label, { 'font-size' => "#{options[:size]}px" }
      )

      text(
        (_s.height / 2).to_i,
        -40,
        value_label, { :transform => 'rotate(90 0,0)', 'font-size' => "#{options[:size]}px" }
      )
    end
  end

  def render_data_layer(l, coords)
    _s = self
    _l = l
    _coords = coords

    # value labels
    if l.value_labels
      t = Time.now

      @image.group :stroke => _s.options[:axis_color], :stroke_width => 1 do
        _coords.each do |c|
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
      _coords.each do |c|
        # additional circle
        circle(c[:ax], c[:ay], 2, { :fill => l.color})
        circle(c[:bx], c[:by], 2, { :fill => l.color})
        # line
        line(
          c[:ax], c[:ay],
          c[:bx], c[:by],
          { }
        )

        _s.drawer.post_dot_drawn(c[:ax], c[:ay])
        _s.drawer.post_dot_drawn(c[:bx], c[:by])
      end
    end

    logger.debug "dots and lines"
    logger.debug " TIME COST #{Time.now - t}"
  end

  def legend(legend_data)
    _s = self

    @image.group :stroke_width => 1, :stroke => '' do
      legend_data.each do |l|
        circle(l[:x], l[:y], 2, { :stroke => l[:color], :fill => l[:color] })
        text(l[:x] + 5, l[:y], l[:label], { :stroke => l[:color], :fill => l[:color] })
      end
    end
  end

# Needed before saving?
  def close
    @image.close if not closed?
    @closed = true
  end

  def closed?
    @closed
  end

  def save(file)
    close

    File.open(file, 'w') do |f|
      f << @image.output
    end
  end

  def to_format(format)
    close

    @image.output
  end

end