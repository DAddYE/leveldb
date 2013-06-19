require 'bundler/gem_tasks'
require 'bundler/setup'
require 'ffi/gen'
require 'yard'

task :check do
  sh 'git submodule update --init' unless File.exist?('ext/leveldb/.git')
  raise "Please install llvm" unless system('which llvm-config')
end

desc "Generates leveldb ext"
task :compile => :check do
  sh 'cd ext && rake'
end

desc "Clean leveldb build"
task :clean do
  sh 'cd ext/leveldb && make clean'
end

desc "Rebuild leveldb"
task :rebuild => [:clean, :compile]

default_config = -> (header, suffix="", extra={}) do
  {
    module_name: 'Leveldb',
    ffi_lib:     'File.expand_path("../../ext/leveldb/libleveldb.#{FFI::Platform::LIBSUFFIX}", __FILE__)',
    headers:     [File.expand_path("../ext/leveldb/include/leveldb/#{header}", __FILE__)],
    cflags:      `llvm-config --cflags`.split(" "),
    prefixes:    ['leveldb_'],
    suffixes:    ['_t', '_s'],
    output:      "lib/leveldb#{suffix}.rb"
  }.merge(extra)
end

desc 'Generates FFI bindings'
task :ffi => :check do
  # Dir['./ext/leveldb/include/leveldb/*.h'].each do |header|
  #   name = File.basename(header, '.h')
  #   FFI::Gen.generate(default_config["#{name}.h", "-#{name}"])
  # end
  FFI::Gen.generate(default_config["c.h"])
end

desc 'Open a console'
task :console do
  ARGV.clear
  require 'irb'
  require 'leveldb'
  IRB.start
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['--markup=markdown',
               '--no-private',
               '--markup-provider=redcarpet']
end
