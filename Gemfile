source "http://rubygems.org"

gemspec

#--- because latest mocha needed a patch to make it work that was not in 3.2.12 yet
gem 'rails', :git => "git://github.com/rails/rails.git", :branch => '3-2-stable'

group :test do
  gem 'mocha', "~> 0.13.0", :require => false
  gem 'debugger'
end
