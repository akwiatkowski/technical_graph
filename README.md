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
 *   options - Hash of parameters, all parameters are described below.

2. Add layer

> tg.add_layer(layer_data)

or

> tg.add_layer(layer_data, layer_params)

where:
 *   layer_data - Array of Hashes, like [{:x => 0, :y => 0}, {:x => 1, :y => 1}, ...]
 *   layer_params - Hash of other parameters, all parameters will be described later.

3. Render graph

> tg.render

4. Save to file

> tg.image_drawer.save_to_file('image.png')

or get image binary content.

> ...


Option's Hash
-----

Default ranges:

 *   options[:x_min]
 *   options[:x_max]
 *   options[:y_min]
 *   options[:y_max]

Ranges calculation mode.
 *   options[:xy_behaviour] = :default - ranges can be enlarged
 *   options[:xy_behaviour] = :fixed - fixed ranges

Axis can be calculated using fixed interval or fixed count per graph.
 *   options[:x_axis_fixed_interval] = true
 *   options[:y_axis_fixed_interval] = true

If fixed interval is set you should specify interval:
 *   options[:y_axis_interval] = 1.0
 *   options[:x_axis_interval] = 1.0

...else, count of axis:
 *   options[:y_axis_count] = 10
 *   options[:x_axis_count] = 10

Labels has truncate string to define precision. Default it is "%.2f".
 *   options[:truncate_string] = "%.2f"


Contributing to technical-graph
-------------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=bobik314&url=https://github.com/akwiatkowski/technical_graph&title=technical_graph&language=en_GB&tags=github&category=software) 

Copyright
---------

Copyright (c) 2011 Aleksander Kwiatkowski. See LICENSE.txt for
further details.

