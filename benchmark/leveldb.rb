require 'bundler/setup'
require 'leveldb'
require 'benchmark'
require 'minitest'

puts '## Please wait, I\'m generating 100mb of random data ...'

N = 10_240
SAMPLE = []

File.open('/dev/urandom', File::RDONLY || File::NONBLOCK || File::NOCTTY) do |f|
  N.times { |i| SAMPLE << f.readpartial(5_120).unpack("H*")[0] }
end

db = LevelDB::DB.new '/tmp/bench', compression: false
db.clear!

puts '## Without compression:'
Benchmark.bm do |x|
  x.report('put') { N.times { |i| db.put(i, SAMPLE[i]) } }
  x.report('get') { N.times { |i| raise unless db.get(i) == SAMPLE[i] } }
end

db.reopen!
puts db.stats
puts

db.close; db.destroy
db = LevelDB::DB.new '/tmp/bench', compression: true
db.clear!

puts '## With compression:'
Benchmark.bm do |x|
  x.report('put') { N.times { |i| db.put(i, SAMPLE[i]) } }
  x.report('get') { N.times { |i| raise unless db.get(i) == SAMPLE[i] } }
end

db.reopen!
puts db.stats
puts

db.close; db.destroy
db = LevelDB::DB.new '/tmp/bench', compression: true
db.clear!

puts '## With batch:'
Benchmark.bm do |x|
  x.report 'put' do
    db.batch do |batch|
      N.times { |i| batch.put(i, SAMPLE[i]) }
    end
  end
end

db.reopen!
puts db.stats
puts
