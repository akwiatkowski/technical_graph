#encoding: utf-8

class DataLayer

  def initialize(d = [], options = { })
    # set data and append initial data
    clear_data
    append_data(d)

    @options = options
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

  attr_reader :data

  # Clear data
  def clear_data
    @data = Array.new
  end

  # Clean and process data used for drawing current data layer
  def process_data
    # delete duplicates
    # TODO: check how it works
    @data = @data.inject([]) { |result,d| result << d unless result.select{|r| r[:x] == d[:x] }.size > 0; result }

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

end