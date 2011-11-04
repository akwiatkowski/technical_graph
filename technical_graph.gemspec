# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{technical_graph}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aleksander Kwiatkowski"]
  s.date = %q{2011-11-05}
  s.description = %q{Purpose of this gem is to create neat, simple, technical graphs. This is alternative to most new libraries which create small, candy graphs using JavaScript.}
  s.email = %q{bobikx@poczta.fm}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "DOCUMENTATION.md",
    "DOCUMENTATION.textile",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/technical_graph.rb",
    "lib/technical_graph/array.rb",
    "lib/technical_graph/data_layer.rb",
    "lib/technical_graph/data_layer_processor.rb",
    "lib/technical_graph/data_layer_processor_noise_removal.rb",
    "lib/technical_graph/data_layer_processor_simple_smoother.rb",
    "lib/technical_graph/data_point.rb",
    "lib/technical_graph/graph_axis.rb",
    "lib/technical_graph/graph_color_library.rb",
    "lib/technical_graph/graph_data_processor.rb",
    "lib/technical_graph/graph_image_drawer.rb",
    "lib/technical_graph/graph_image_drawer_module.rb",
    "lib/technical_graph/graph_image_drawer_rasem.rb",
    "lib/technical_graph/graph_image_drawer_rmagick.rb",
    "test/helper.rb",
    "test/test_technical_autocolor.rb",
    "test/test_technical_axis_enlarge.rb",
    "test/test_technical_graph.rb",
    "test/test_technical_graph_axis.rb",
    "test/test_technical_multilayer.rb",
    "test/test_technical_noise_removal.rb",
    "test/test_technical_rasem.rb",
    "test/test_technical_readme.rb",
    "test/test_technical_simple_graph.rb",
    "test/test_technical_smoother.rb",
    "test/test_technical_smoother_adv.rb"
  ]
  s.homepage = %q{http://github.com/akwiatkowski/technical_graph}
  s.licenses = ["LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Create simple and neat graphs}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmagick>, [">= 0"])
      s.add_runtime_dependency(%q<rasem>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rmagick>, [">= 0"])
      s.add_dependency(%q<rasem>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rmagick>, [">= 0"])
    s.add_dependency(%q<rasem>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

