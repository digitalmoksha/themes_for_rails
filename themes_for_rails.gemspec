
# -*- encoding: utf-8 -*-
require File.expand_path('../lib/themes_for_rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lucas Florio"]
  gem.email         = ["lucasefe@gmail.com"]
  gem.summary       = "Theme Support for Rails 3"
  gem.description   = %q{It allows an application to have many different ways of rendering static assets and dynamic views.}
  gem.homepage      = "https://github.com/lucasefe/themes_for_rails"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "themes_for_rails"
  gem.require_paths = ["lib"]
  gem.version       = ThemesForRails::VERSION

  gem.add_dependency 'rails', ">= 7.0"
end
