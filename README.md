# Leveldb

Experimental FFI bindings for leveldb

## Documentation

* [Website](http://daddye.it/leveldb)
* [Api Doc](http://daddye.it/leveldb/doc)

## Installation

    $ brew install snappy
    $ git clone git://github.com/DAddYE/leveldb.git
    $ cd leveldb
    $ rake compile
    $ rake console

## Usage

Here a basic usage, for more advanced please see the doc.

Right now is very **low** level, I'm planning to add an higher layer api.

### Prepare

If you plan to hack in a console ...

Remember that `err` is important, we are going to use this var in all our calls

```rb
require 'leveldb'

include Leveldb

err = err_create
```

### Open

```ruby
options = options_create
options.set_create_if_missing 1
db = open options, './tmp/testdb', err

abort err.message unless err.null?
```

### Write

```ruby
write_opts = writeoptions_create
put(db, write_opts, "key", "value", err)

abort err.message unless err.null?
```

### Read

```ruby
read_opts = readoptions_create
read = get(db, read_opts, "key", 3, read_len, err)

abort err.message unless err.null?
puts "Key is: #{read}"
```

### Delete

```ruby
delete(db, write_opts, "key", 3, err)

abort err.message unless err.null?
```

### Close (connection)

```ruby
db.close
```

### Destroy (database)

```ruby
destroy_db(options, './tmp/testdb', err)

abort err.message unless err.null?
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
