# Leveldb

LevelDB on Ruby

## Documentation

* [Website](http://daddye.it/leveldb)
* [Api Doc](http://daddye.it/leveldb/doc)

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

Here a basic usage, for more advanced please see the doc.

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
```

## Todo

1. Add support for full `write` and `read` options
2. Add snapshots
3. Add pluggable serializers

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
