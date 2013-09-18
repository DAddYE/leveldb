require 'bundler/setup'
require 'leveldb'
require 'pp'

GC::Profiler.enable

db = LevelDB::DB.new("/tmp/leaktest")
p db.get 'fox'

10_000_000.times { db.get 'fox' }

counts = Hash.new(0)
ObjectSpace.each_object do |o|
  counts[o.class] += 1
end

pp counts.sort_by { |k, v| v }

puts GC::Profiler.result
# puts GC::Profiler.raw_data


sleep
