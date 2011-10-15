technical_graph
===============

Purpose of this gem is to create neat, meaningful, linear graphs for large amount of data.

If you want to:

* create big graphs using large amount of data,
* do it offline,
* minimize needed code,
* use only linear graph,
* speed is not essential,
* RMagick / ImageMagick is ok for you,
* tired of forgotten gems/libraries...

then you should try this gem.

I created it because there were not available and maintained gems for that I needed. Now I use it to create hourly
temperature and wind graphs for vast period of time (months, years), visualize measurements for [HomeIO](https://github.com/akwiatkowski/HomeIO).

If you want to create candy, ultra fast, web graphs it maybe not the best tool. If you want other graph types than linear it
is definitely not the right tool for you. It is also not SVG ready yet, but it should be within a few months.
You can find my competitors [here](https://www.ruby-toolbox.com/categories/graphing).


Future
------

1. Finish data processors: smoothing (nearly done), noise removal (50%), interpolation or curved graphs (planned).
2. Fix export to SVG.
3. Optimization, and if needed find or write something faster for creating SVGs.


Quick start
-----------

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
* layer_params - Hash of other parameters, all parameters are described later.

3. Render graph

> tg.render

4. Save to file

> tg.image_drawer.save_to_file('image.png')

or get image binary content.

> tg.image_drawer.to_format(format)

where format is image format, ex. 'png', 'jpeg', ... Of coure I prefer 'png'.


Documentation
-------------

Documentation is moved [here](https://github.com/akwiatkowski/technical_graph/blob/master/DOCUMENTATION.md)


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

