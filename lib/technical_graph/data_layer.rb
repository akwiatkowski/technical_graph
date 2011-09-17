#encoding: utf-8

# Stores only data used for one layer
# Instances of this class are used elsewhere
# Stores also drawing parameters for one layer

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

  # Array of {:x =>, :y =>}
  attr_reader :data

  # Additional parameters
  attr_reader :data_params

  # Color of
  def color
    return @data_params[:color] || 'blue'
  end

  def antialias
    return @data_params[:antialias] == false
  end

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

end