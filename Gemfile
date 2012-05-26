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

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rdoc"
  #gem "shoulda"
  gem "bundler", "~> 1.0.0"
  gem "rspec"
  gem "jeweler" #, "~> 1.6.4"
  gem "simplecov", ">= 0"
end
