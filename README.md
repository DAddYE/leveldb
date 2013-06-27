# Leveldb

LevelDB is a database library (C++, 350 kB) written at Google. It is an
embedded database. LevelDB is a persistent ordered map.

> LevelDB stores keys and values in arbitrary byte arrays, and data is sorted by
> key. It supports batching writes, forward and backward iteration, and
> compression of the data via Google's Snappy compression library.  Still,
> LevelDB is not a SQL database. (Wikipedia)

## Features

* Keys and values are arbitrary byte arrays.
* Data is stored **sorted** by key.
* Callers can provide a (_soon_) **custom comparison** function to override the sort order.
* The basic operations are Put(key,value), Get(key), Delete(key).
* Multiple changes can be made in one **atomic batch**.
* Users can create a **transient snapshot** to get a consistent view of data.
* _Forward_ and _backward_ iteration is supported over the data.
* Data is automatically **compressed** using the **Snappy** compression library.
* External activity (file system operations etc.) is relayed through a virtual
  interface so users can customize the operating system interactions.
* Detailed documentation about how to use the library is included
  with the [source code](http://code.google.com/p/leveldb/).

## Reading

* [LevelDB](http://code.google.com/p/leveldb/)
* [Great Reading](http://skipperkongen.dk/2013/02/14/having-a-look-at-leveldb/)
* [Website](http://daddye.it/leveldb)

## Installation

### Development

    $ brew install snappy
    $ git clone git://github.com/DAddYE/leveldb.git
    $ cd leveldb
    $ rake compile
    $ rake console

### Standard

    $ brew install snappy
    $ gem install leveldb
    $ irb -r leveldb

## Usage

Here a basic usage:

```rb
db = LevelDB::DB.new '/tmp/foo'

# Writing
db.put('hello', 'world')
db['hello'] = 'world'

# Reading
db.get('hello') # => world
db['hello'] # => world
db.exists?('hello') # => true

# Reading/Writing
db.fetch('hello', 'hello world') # => will write 'hello world' if there is no key 'hello'
db.fetch('hello'){ |key| 'hello world' } # => same as above

# Deleting
db.delete('hello')

# Iterating
db.each { |key, val| puts "Key: #{key}, Val: #{val}" }
db.reverse_each { |key, val| puts "Key: #{key}, Val: #{val}" }
db.keys
db.values
db.map { |k,v| do_some_with(k, v) }
db.reduce([]) { |memo, (k, v)| memo << k + v; memo }
db.each # => enumerator
db.reverse_each # => enumerator

# Ranges
db.range('c', 'd') { |k,v| do_some_with_only_keys_in_range }
db.reverse_range('c', 'd') # => same as above but results are in reverse order
db.range(...) # => enumerable

# Batches
db.batch do |b|
  b.put 'a', 1
  b.put 'b', 2
  b.delete 'c'
end

b = db.batch
b.put 'a', 1
b.put 'b', 2
b.delete 'c'
b.write!

# Snapshots
db.put 'a', 1
db.put 'b', 2
db.put 'c', 3

snap = db.snapshot

db.delete 'a'
db.get 'a' # => nil

snap.set!

db.get('a') # => 1

snap.reset!

db.get('a') # => nil

snap.set!

db.get('a') # => 1

# Properties
db.read_property('leveldb.stats')

# Level  Files Size(MB) Time(sec) Read(MB) Write(MB)
# --------------------------------------------------
#   0        1        0         0        0         0
#   1        1        0         0        0         0

# same of:
db.stats
```

## Benchmarks

_Preface_: those are only for general purpose, I know that [zedshaw](http://zedshaw.com/essays/programmer_stats.html)
will kill me for this, but ... on my mac:

    Model Identifier:	MacBookPro10,1
    Processor Name:	Intel Core i7
    Processor Speed:	2.3 GHz
    Number of Processors:	1
    Total Number of Cores:	4
    L2 Cache (per Core):	256 KB
    L3 Cache:	6 MB
    Memory:	8 GB

The benchmark code is in [benchmark/leveldb.rb](/benchmark/leveldb.rb)

Writing/Reading `100mb` of _very_ random data of `10kb` each:

### Without compression:

          user     system      total        real
    put  0.530000   0.310000   0.840000 (  1.420387)
    get  0.800000   0.460000   1.260000 (  2.626631)

    Level  Files Size(MB) Time(sec) Read(MB) Write(MB)
    --------------------------------------------------
      0        1        0         0        0         0
      2       50       98         0        0         0
      3        1        2         0        0         0

### With compression:

          user     system      total        real
    put  0.850000   0.320000   1.170000 (  1.721609)
    get  1.160000   0.480000   1.640000 (  2.703543)

    Level  Files Size(MB) Time(sec) Read(MB) Write(MB)
    --------------------------------------------------
      0        1        0         0        0         0
      1        5       10         0        0         0
      2       45       90         0        0         0

**NOTE**: as you can see `snappy` can't compress that kind of _very very_
random data, but I was not interested to bench snappy (as a compressor) but
only to see how (eventually) much _slower_ will be using it. As you can see,
only a _few_ and on normal _data_ the db size will be much much better!

### With batch:

          user     system      total        real
    put  0.260000   0.170000   0.430000 (  0.433407)

    Level  Files Size(MB) Time(sec) Read(MB) Write(MB)
    --------------------------------------------------
      0        1      100         1        0       100


## Difference between a c++ pure ruby impl?

This, again, only for general purpose, but I want to compare the `c++` implementation
of [leveldb-ruby](https://github.com/wmorgan/leveldb-ruby) with this that use ffi.

I'm aware that this lib is 1 year older, but for those who cares, the basic bench:

          user     system      total        real
    put  0.440000   0.300000   0.740000 (  1.363188)
    get  0.440000   0.440000   1.460000 (  2.407274)

## Todo

1. Add pluggable serializers
2. Custom comparators

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
