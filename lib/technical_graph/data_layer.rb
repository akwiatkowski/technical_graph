#encoding: utf-8

class DataLayer

  def initialize(d = [], options = { })
    @options = options
    @data_params = Hash.new

    # set data and append initial data
    clear_data
    append_data(d)
  end

  # Accessor for setting chart data for layer to draw
  def append_data(d)
    if d.kind_of? Array
      @data += d
      # sort, clean bad records
      process_data
    else
      raise 'Data not an Array'
    end
  end

  attr_reader :data, :data_params

  # Clear data
  def clear_data
    @data = Array.new
  end

  # Clean and process data used for drawing current data layer
  def process_data
    # delete duplicates
    @data = @data.inject([]) { |result, d| result << d unless result.select { |r| r[:x] == d[:x] }.size > 0; result }

    @data.delete_if { |d| d[:x].nil? or d[:y].nil? }
    @data.sort! { |d, e| d[:x] <=> e[:x] }

    @data_params = Hash.new
    # default X values, if data is not empty
    if @data.size > 0
      @data_params[:x_min] = @data.first[:x] || @options[:default_x_min]
      @data_params[:x_max] = @data.last[:x] || @options[:default_x_max]

      # default Y values
      y_sort = @data.sort { |a, b| a[:y] <=> b[:y] }
      @data_params[:y_min] = y_sort.first[:y] || @options[:default_y_min]
      @data_params[:y_max] = y_sort.last[:y] || @options[:@default_y_max]
    end

  end

  def x_min
    @data_params[:x_min]
  end

  def x_max
    @data_params[:x_max]
  end

  def y_min
    @data_params[:y_min]
  end

  def y_max
    @data_params[:y_max]
  end

  # Render axis on image
  def render_on_image(image, axis)
    @image = image
    @axis = axis

    render_layer
  end

  # TODO: refactor
  def render_layer
    layer_line = Magick::Draw.new
    layer_text = Magick::Draw.new

    layer_line.fill_opacity(0)
    layer_line.stroke(@image.options[:axis_color])
    layer_line.stroke_opacity(1.0)
    layer_line.stroke_width(1.0)
    layer_line.stroke_linecap('square')
    layer_line.stroke_linejoin('miter')

    layer_text.font_family('helvetica')
    layer_text.font_style(Magick::NormalStyle)
    layer_text.text_align(Magick::LeftAlign)
    layer_text.text_undercolor(@image.options[:background_color])


    (0...(@data.size - 1)).each do |i|
      puts "Plotting #{i}/#{@data.size}"

      ax = @data[i][:x]
      ax = @axis.calc_bitmap_x(ax).round
      ay = @data[i][:y]
      ay = @axis.calc_bitmap_y(ay).round

      bx = @data[i+1][:x]
      bx = @axis.calc_bitmap_x(bx).round
      by = @data[i+1][:y]
      by = @axis.calc_bitmap_y(by).round

      layer_line.line(
        ax, ay,
        bx, by
      )

      #layer_text.text(
      #  ax, ay,
      #  "(#{@data[i][:x]},#{@data[i][:y]})"
      #)
    end

    t = Time.now
    layer_line.draw(@image.image)
    puts "#{Time.now - t} drawing lines"
    layer_text.draw(@image.image)
    puts "#{Time.now - t} drawing text"

  end

end