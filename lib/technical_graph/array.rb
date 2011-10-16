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
end
