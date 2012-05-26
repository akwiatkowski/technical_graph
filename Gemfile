# hack for loading gems if they were are available to add
# some optional features
def gem_available?(name)
   Gem::Specification.find_by_name(name)
rescue Gem::LoadError
   false
rescue
   Gem.available?(name)
end


source "http://rubygems.org"

# SVG
gem 'rasem'

# PNG
gem 'chunky_png'
gem 'rmagick' if gem_available? 'rmagick'
gem 'oily_png' if gem_available? 'oily_png'

# optional gem - creating graphs using ImageMagic
#if Gem.source_index.find_name('rmagick').size > 0
#  gem 'rmagick'
#end
# optional gem - chunky_png C addon
#if Gem.source_index.find_name('oily_png').size > 0
#  gem 'oily_png'
#end

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rdoc"
  gem "shoulda"
  gem "bundler", "~> 1.0.0"
  gem "rspec"
  gem "jeweler" #, "~> 1.6.4"
  gem "simplecov", ">= 0"
end
