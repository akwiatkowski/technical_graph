How to use it
=============

All this examples are generated in test/test_technical_readme.rb.


First thing we need to have data to show on graph, for example something like:

> simple_data_array = [
>   { :x => 0, :y => 0 },
>   { :x => 1, :y => 1 },
>   { :x => 2, :y => 2 },
>   { :x => 3, :y => 2 },
>   { :x => 4, :y => 1 },
>   { :x => 5, :y => 0 },
> ]

If you want to put this data on graph you need to create TechnicalGraph object

> tg = TechnicalGraph.new

and add a layer.

> tg.add_layer(simple_data_array)

We added data but we don't see anything. Now we have to render graph and save it to file.

> tg.render
> file_name = 'samples/readme/01_simplest.png'
> @tg.image_drawer.save_to_file(file_name)

And we got our first graph with one layer without any options changes, a bit raw.

![(01) simple graph](https://github.com/akwiatkowski/technical_graph/blob/master/samples/readme/01_simplest.png)





 Maybe example with two layers?

> simple_data_array = [
>   { :x => 0, :y => 0 },
>   { :x => 1, :y => 1 },
>   { :x => 2, :y => 2 },
>   { :x => 3, :y => 2 },
>   { :x => 4, :y => 1 },
>   { :x => 5, :y => 0 },
> ]
> simple_data_array_b = [
>   { :x => 0.5, :y => 0.5 },
>   { :x => 1.5, :y => 0.5 },
>   { :x => 2.5, :y => 1.5 },
>   { :x => 3.5, :y => 1.0 },
>   { :x => 4.5, :y => 1.5 },
>   { :x => 5.5, :y => 1.5 },
> ]

> tg = TechnicalGraph.new
> tg.add_layer(simple_data_array)
> tg.add_layer(simple_data_array_b)
> tg.render
> file_name = 'samples/readme/02_two_layers.png'
> @tg.image_drawer.save_to_file(file_name)

![(02) simple graph](https://github.com/akwiatkowski/technical_graph/blob/master/samples/readme/02_two_layers.png)


Options Hash
-------------

Default ranges:

* options[:x_min]
* options[:x_max]
* options[:y_min]
* options[:y_max]

Ranges calculation mode:

* options[:xy_behaviour] = :default - ranges can be enlarged
* options[:xy_behaviour] = :fixed - fixed ranges

Axis can be calculated using fixed interval or fixed count per graph.

* options[:x_axis_fixed_interval] = true
* options[:y_axis_fixed_interval] = true

If fixed interval is set you should specify interval:

* options[:y_axis_interval] = 1.0
* options[:x_axis_interval] = 1.0

...else, count of axis:

* options[:y_axis_count] = 10
* options[:x_axis_count] = 10

Axis labels:

* options[:x_axis_label] = 'x'
* options[:y_axis_label] = 'y'


Labels has truncate string to define precision. Default it is "%.2f".

* options[:truncate_string] = "%.2f"

Graph image size:

* options[:width]
* options[:height]

Colors:

Possible #RRGGBB or color names (ex. 'white').

* options[:background_color] - background color of image
* options[:background_hatch_color] - background hatch color
* options[:axis_color] - color of axis

Anti-aliasing:

* options[:axis_antialias] - use anti-aliasing for axis, default false
* options[:layers_antialias] - use anti-aliasing for data layers, default false, can be override using layer option
* options[:font_antialias] - use anti-aliasing for all fonts, default false

Font size:

* options[:layers_font_size] - size of font used for values in graph
* options[:axis_font_size] - size of font used in axis
* options[:axis_label_font_size] - size of font used in options[:x_axis_label] and options[:y_axis_label]

Sometime because of axis options and large amount of data, axis can be put densely on graph. Turning this option graph
size will be enlarged to maintain set distanced between axis.

* options[:axis_density_enlarge_image] - turn this options on
* options[:x_axis_min_distance] - minimum distance between X axis, default 30 pixels
* options[:y_axis_min_distance] - minimum distance between X axis, default 50 pixels

Legend options:

* options[:legend] - do you want to draw legend?, default false
* options[:legend_auto] - let legend position to be chosen by algorithm, default true
* options[:legend_width] - width used for setting proper distance while drawing on right, default 100, legend height is calculated
* options[:legend_margin] - graph margin used not to draw legend on border, default 50
* options[:legend_x] - legend X position, used when options[:legend_auto] is false, default 50
* options[:legend_y] - legend Y position, used when options[:legend_auto] is false, default 50


Layer options Hash
------------------

* layer_options[:label] - label used in legend
* layer_options[:color] - color of graph layer, ex.: 'red', 'green', '#FFFF00'
* layer_options[:antialias] - use anti-aliasing for this, default false, override options[:layers_antialias]
* layer_options[:value_labels] - write values near 'dots', default true
* layer_options[:simple_smoother] - 'smooth' data, default false
* layer_options[:simple_smoother_level] - strength of smoothing, this is level of window used for processing, default 3
* layer_options[:simple_smoother_strategy] - strategy used for smoothing data, you can choose between :rectangular or :gauss, default :rectangular
* layer_options[:simple_smoother_x] - consider X axis distance when smoothing, slowest but more accurate, default false
* layer_options[:noise_removal] - enable removal of noises/peaks, default false
* layer_options[:noise_removal_level] - tolerance level, higher - less points will be removes, default 3
* layer_options[:noise_removal_window_size] - how many near values check for determining what is noise, default 10
