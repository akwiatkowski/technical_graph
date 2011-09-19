# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{technical_graph}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aleksander Kwiatkowski"]
  s.date = %q{2011-09-19}
  s.description = %q{Create simple and neat graphs}
  s.email = %q{bobikx@poczta.fm}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".idea/dictionaries/olek.xml",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/technical_graph.rb",
    "lib/technical_graph/data_layer.rb",
    "lib/technical_graph/graph_axis.rb",
    "lib/technical_graph/graph_data_processor.rb",
    "lib/technical_graph/graph_image_drawer.rb",
    "lib/technical_graph/refactoring_backup/lib/technical_graph.rb",
    "lib/technical_graph/refactoring_backup/lib/technical_graph/axis_layer.rb",
    "lib/technical_graph/refactoring_backup/lib/technical_graph/axis_layer_draw_module.rb",
    "lib/technical_graph/refactoring_backup/test/test_technical_graph.rb",
    "lib/technical_graph/refactoring_backup/test/test_technical_graph_axis.rb",
    "samples/1.png",
    "test/helper.rb",
    "test/test_technical_graph.rb",
    "test/test_technical_graph_axis.rb",
    "test/test_technical_simple_graph.rb"
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
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rmagick>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rmagick>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

