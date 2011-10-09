technical-graph
===============

Create neat graphs.


Usage
-----

Check currents test when documentation is not enough :)

1. Create instance

> tg = TechnicalGraph.new

or

> tg = TechnicalGraph.new( options )

where:

* options - Hash of parameters, all parameters are described below.

2. Add layer

> tg.add_layer(layer_data)

or

> tg.add_layer(layer_data, layer_params)

where:

* layer_data - Array of Hashes, like [{:x => 0, :y => 0}, {:x => 1, :y => 1}, ...]
* layer_params - Hash of other parameters, all parameters will be described later.

3. Render graph

> tg.render

4. Save to file

> tg.image_drawer.save_to_file('image.png')

or get image binary content.

> tg.image_drawer.to_format(format)

where format is image format, ex. 'png', 'jpeg', ...


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


Layer options Hash
------------------

* layer_options[:color] - color of graph layer, ex.: 'red', 'green', '#FFFF00'
* layer_options[:antialias] - use anti-aliasing for this, default false, override options[:layers_antialias]


Contributing to technical-graph
-------------------------------

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=bobik314&url=https://github.com/akwiatkowski/technical_graph&title=technical_graph&language=en_GB&tags=github&category=software)

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


Copyright
---------

Copyright (c) 2011 Aleksander Kwiatkowski. See LICENSE.txt for
further details.

