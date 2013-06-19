source 'https://rubygems.org'
gemspec

gem 'yard'
gem 'redcarpet'

if dev_ffi = File.expand_path('../../ffi-gen', __FILE__) and File.exist?(dev_ffi)
  gem 'ffi-gen', require: 'ffi/gen', path: dev_ffi
else
  gem 'ffi-gen', require: 'ffi/gen', github: 'DAddYE/ffi-gen'
end
