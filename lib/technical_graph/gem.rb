def gem_available?(name)
   Gem::Specification.find_by_name(name)
rescue Gem::LoadError
   false
rescue
   Gem.available?(name)
end

# Check if rmagick is installed
def rmagick_installed?
  gem_available?('rmagick')
end
