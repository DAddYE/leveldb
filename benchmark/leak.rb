require 'bundler/setup'
require 'leveldb'

GC::Profiler.enable

db = LevelDB::DB.new("/tmp/leaktest")
p db.get 'fox'

1000000.times { db.get 'fox' }

puts GC::Profiler.result
puts GC::Profiler.raw_data
