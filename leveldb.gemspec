# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'leveldb/version'

Gem::Specification.new do |spec|
  spec.name          = "leveldb"
  spec.version       = LevelDB::VERSION
  spec.authors       = ["DAddYE"]
  spec.email         = ["info@daddye.it"]
  spec.description   = "LevelDB for Ruby"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/DAddYE/leveldb"
  spec.license       = "MIT"
  spec.files         = []

  if RUBY_PLATFORM =~ /java/
    spec.platform = "java"
  else
    spec.extensions = Dir["ext/Rakefile"]
    spec.files += Dir["ext/leveldb/**/*.{c,cc,h,mk,d}"] -
      Dir["ext/leveldb/doc/*"] +
      Dir["ext/leveldb/LICENSE"] +
      Dir["ext/leveldb/Makefile"] +
      Dir["ext/leveldb/build_detect_platform"]
  end

  spec.files        += Dir['lib/**/*.rb']
  spec.files        += %w[README.md LICENSE.txt]
  spec.executables   = Dir['bin/**/*']
  spec.test_files    = Dir['test/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_dependency "fiddler-rb", "~> 0.1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "ffi"
end
