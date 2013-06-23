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

## Todo

1. Add pluggable serializers
2. Custom comparators

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
