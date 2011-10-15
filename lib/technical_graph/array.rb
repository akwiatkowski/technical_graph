#encoding: utf-8

# Additional methods for array
# http://stackoverflow.com/questions/1341271/average-from-a-ruby-array

class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean
    sum / size
  end
end
