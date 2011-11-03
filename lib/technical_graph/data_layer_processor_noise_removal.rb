#encoding: utf-8

require 'technical_graph/array'

module DataLayerProcessorNoiseRemoval
  DEFAULT_NOISE_REMOVAL_LEVEL = 3
  DEFAULT_NOISE_REMOVAL_WINDOW_SIZE = 10

  def noise_removal_initialize(options)
    @noise_removal = options[:noise_removal] == true
    @noise_removal_level = options[:noise_removal_level] || DEFAULT_NOISE_REMOVAL_LEVEL
    @noise_removal_window_size = options[:noise_removal_window_size] || DEFAULT_NOISE_REMOVAL_WINDOW_SIZE
  end

  attr_accessor :noise_removal_level, :noise_removal_window_size, :noise_removal

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

    part_array = data.clone_partial_w_fill(i_from, i_to)
    y_mean = part_array.collect { |p| p.y }.float_mean

    # another algorithm
    noise_strength = (data[i].y - y_mean).abs / y_mean
    return noise_strength_enough?(noise_strength)
  end

  # Some magic here, beware
  def noise_strength_enough?(noise_strength)
    threshold_strength = Math.log(@noise_removal_level)
    return noise_strength > threshold_strength
  end


end