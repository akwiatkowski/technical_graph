#encoding: utf-8

require 'technical_graph/array'

module DataLayerProcessorNoiseRemoval
  DEFAULT_NOISE_REMOVAL_LEVEL = 3
  DEFAULT_NOISE_REMOVAL_WINDOW_SIZE = 10

  NOISE_COEFF = 1000
  NOISE_POWER_COEFF = 8

  def noise_removal_initialize(options)
    @noise_removal = options[:noise_removal] == true
    @noise_removal_level = options[:noise_removal_level] || DEFAULT_NOISE_REMOVAL_LEVEL
    @noise_removal_window_size = options[:noise_removal_window_size] || DEFAULT_NOISE_REMOVAL_WINDOW_SIZE

    @noise_threshold = Math.log(NOISE_COEFF / @noise_removal_level)
  end

  attr_accessor :noise_removal_level, :noise_removal_window_size, :noise_removal, :noise_threshold

  # Smooth values
  def noise_removal_process
    return if noise_removal == false

    t = Time.now
    new_data = Array.new

    @noises_removed_count = 0

    logger.debug "Noise removal started"

    (0...data.size).each do |i|
      if not noise?(i)
        new_data << data[i]
      else
        @noises_removed_count += 1
      end
    end

    logger.debug "Noise removal completed, removed #{@noises_removed_count}"
    logger.debug " TIME COST #{Time.now - t}"

    @data = new_data
    return new_data
  end

  def noise_removal_window_from(i)
    return i - (noise_removal_window_size.to_f / 2.0).ceil
  end

  def noise_removal_window_to(i)
    return i + (noise_removal_window_size.to_f / 2.0).ceil
  end

  # Check if data at index is noisy
  def noise?(i)
    i_from = noise_removal_window_from(i)
    i_to = noise_removal_window_to(i)


    # y_mean = part_array.collect { |p| p.y }.float_mean
    # # another algorithm
    # noise_strength = (data[i].y - y_mean).abs / y_mean
    # return noise_strength_enough?(noise_strength)

    # calc. avg 'derivative'
    avg_der = calc_avg_derivative(i_from, i_to)
    current_der = calc_avg_derivative(i-1, i+1)

    # safety
    return false if avg_der == 0 or current_der == 0

    begin
      current_level = Math.log((current_der / avg_der) ** NOISE_POWER_COEFF).abs
    rescue Errno::EDOM
      # can not calculate logarithm
      return false
    rescue Errno::ERANGE
      # can not calculate logarithm
      return false
    end
    logger.debug "noise removal, avg der #{avg_der}, current #{current_der}, current lev #{current_level}, threshold #{noise_threshold}"
    return current_level > noise_threshold
  end

  def calc_avg_derivative(i_from, i_to)
    part_array = data.clone_partial_w_fill(i_from, i_to)
    derivatives = Array.new
    (1...part_array.size).each do |i|
      x_len = (part_array[i].x - part_array[i - 1].x).abs
      y_len = (part_array[i].y - part_array[i - 1].y).abs
      derivatives << (x_len / y_len).abs if x_len.abs > 0
    end
    avg_der = derivatives.float_mean
    return avg_der
  end

  ## Some magic here, beware
  #def noise_strength_enough?(noise_strength)
  #  threshold_strength = Math.log(@noise_removal_level)
  #  logger.debug "Noise removal noise str #{noise_strength}, threshold #{threshold_strength}"
  #  return noise_strength > threshold_strength
  #end


end