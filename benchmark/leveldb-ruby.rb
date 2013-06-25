require 'leveldb' # be sure to a) don't add bundler/setup b) gem uninstall leveldb
require 'benchmark'
require 'minitest'

puts '## Please wait, I\'m generating 100mb of random data ...'

N = 10_240
SAMPLE = []

File.open('/dev/urandom', File::RDONLY || File::NONBLOCK || File::NOCTTY) do |f|
  N.times { |i| SAMPLE << f.readpartial(5_120).unpack("H*")[0] }
end

system 'rm -rf /tmp/bench'
db = LevelDB::DB.new '/tmp/bench', compression: LevelDB::CompressionType::NoCompression
puts '## Without compression:'
Benchmark.bm do |x|
  x.report('put') { N.times { |i| db.put(i.to_s, SAMPLE[i]) } }
  x.report('get') { N.times { |i| raise unless db.get(i.to_s) == SAMPLE[i] } }
end
db.close

system 'rm -rf /tmp/bench'
db = LevelDB::DB.new '/tmp/bench', compression: LevelDB::CompressionType::SnappyCompression
puts '## With compression:'
Benchmark.bm do |x|
  x.report('put') { N.times { |i| db.put(i.to_s, SAMPLE[i]) } }
  x.report('get') { N.times { |i| raise unless db.get(i.to_s) == SAMPLE[i] } }
end
db.close

system 'rm -rf /tmp/bench'
db = LevelDB::DB.new '/tmp/bench', compression: LevelDB::CompressionType::SnappyCompression
puts '## With batch:'
Benchmark.bm do |x|
  x.report 'put' do
    db.batch do |batch|
      N.times { |i| batch.put(i, SAMPLE[i]) }
    end
  end
end
db.close
