#encoding: utf-8

module DataLayerProcessorNoiseRemoval
  DEFAULT_NOISE_REMOVAL_LEVEL = 3

  def noise_removal_initialize
    @noise_removal_level = DEFAULT_NOISE_REMOVAL_LEVEL
  end

  attr_accessor :noise_removal_level

  # Smooth values
  def noise_removal_process
    t = Time.now
    old_data = @data
    new_data = Array.new

    puts "Noise removal started"

    (0...old_data.size).each do |i|
      new_data << old_data[i] if not noise?(i)
    end

    puts "Noise removal completed time #{Time.now - t}"

    @data = new_data
    return new_data
  end

  # Check if data at index is noisy
  def noise?(i)
    return false
  end


end