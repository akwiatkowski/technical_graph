module AxisLayerDrawModule
  def x_axis_fixed?
     @options[:x_axises_fixed_count] == true
   end

  def y_axis_fixed?
     @options[:y_axises_fixed_count] == true
   end

  # Where to put axis values
  def value_axises
    l = self.y_max - self.y_min
    a = Array.new
    if y_axis_fixed?
    end
  end

  # Render axis on image
  def render_on_image(image)
    @image = image
    # TODO
  end
end