#encoding: utf-8

require 'singleton'

# Used for auto color grabber

class GraphColorLibrary
  include Singleton
  
  # http://www.imagemagick.org/script/color.php
  BASIC_COLORS = [
    'blue',
    'red',
    'green',
    'purple'
  ]

  ADDITIONAL_COLORS = [
    'tomato',
    'sienna1',
    'chocolate2',
    'DarkGoldenrod4',
    'OliveDrab4',
    'ForestGreen',
    'turquoise',
    'DarkCyan',
    'CadetBlue4',
    'DeepSkyBlue4',
    'DodgerBlue2',
    'CornflowerBlue',
    'MidnightBlue',
    'MediumPurple3',
    'magenta4',
    'orchid4',
    'DeepPink3',
    'PaleVioletRed4',
    'firebrick3'
  ]

  FAIL_COLOR = 'black'

  def initialize
    @colors = BASIC_COLORS + ADDITIONAL_COLORS.sort {rand}
  end

  def get_color
    color = @colors.shift
    return FAIL_COLOR if color.nil?
    return color
  end

end