#encoding: utf-8

# Additional methods for array
# http://stackoverflow.com/questions/1341271/average-from-a-ruby-array

class Array
  def float_sum
    inject(0.0) { |result, el| result + el }
  end

  def float_mean
    float_sum / size
  end

  # Create partial array and fill with border values if needed
  def clone_partial_w_fill(_from, _to)
    part_array = Array.new
    # border = false

    (_from.._to).each do |current_i|
      # outside ranges
      if current_i < 0
        part_array << self.first
        # border = true
        next
      end

      if self.size <= current_i
        part_array << self.last
        # border = true
        next
      end

      part_array << self[current_i]
    end

    return part_array
  end
end
