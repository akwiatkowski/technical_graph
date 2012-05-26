#encoding: utf-8

require 'singleton'

# Used for auto color grabber

class GraphColorLibrary
  include Singleton

  # rock solid colors
  # http://www.imagemagick.org/script/color.php
  BASIC_COLORS = [
    '#0000FF', #'blue',
    '#FF0000', #'red',
    '#00FF00', #'green',
    '#FF00FF', #'purple'
  ]

  # other random picked up, SVG need #RGB and I'm too lazy :]
  ADDITIONAL_COLORS = [
    '#8B3626', #'tomato',
    '#FF8247', #'sienna1',
               #'chocolate2',
               #'DarkGoldenrod4',
               #'OliveDrab4',
               #'ForestGreen',
               #'turquoise',
               #'DarkCyan',
               #'CadetBlue4',
               #'DeepSkyBlue4',
               #'DodgerBlue2',
               #'CornflowerBlue',
               #'MidnightBlue',
               #'MediumPurple3',
               #'magenta4',
               #'orchid4',
               #'DeepPink3',
               #'PaleVioletRed4',
               #'firebrick3'
  ]

  FAIL_COLOR = '#000000' #'black'

  def initialize
    reset
  end

  # Reset color bank
  def reset
    @colors = BASIC_COLORS + ADDITIONAL_COLORS.sort { rand }
  end

  # not too bright
  MAX_INTENSITY = 0xbb

  # Best solution, create random color JIT
  def random_color
    str = "#"
    3.times do
      str += colour = "%02x" % (rand * MAX_INTENSITY)
    end
    return str
  end

  def get_color
    color = @colors.shift
    #return FAIL_COLOR if color.nil?
    # better, create random colors just in time
    return random_color if color.nil?
    return color
  end

end