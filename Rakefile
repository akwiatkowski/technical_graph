# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

# http://technicalpickles.com/posts/craft-the-perfect-gem-with-jeweler/
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "technical_graph"
  gem.homepage = "http://github.com/akwiatkowski/technical_graph"
  gem.license = "LGPLv3"
  gem.summary = %Q{Create simple and neat graphs}
  gem.description = %Q{Purpose of this gem is to create neat, simple, technical graphs. This is alternative to most new libraries which create small, candy graphs using JavaScript.}
  gem.email = "bobikx@poczta.fm"
  gem.authors = ["Aleksander Kwiatkowski"]

  #gem.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*", 'lib/jeweler/templates/.gitignore']
  gem.files = FileList[
    "[A-Z]*", "{bin,generators,lib,test}/**/*"
  ]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Remove all images created during tests"
task :clean do
  `rm samples/tests/*.svg`
  `rm samples/tests/*.png`
end

desc "Clean and release"
task :clean_and_release => [:clean, :release] do
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gpx2exif #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Run RSpec with code coverage"
task :coverage do
  `rake spec COVERAGE=true`
  #`open coverage/index.html`
end