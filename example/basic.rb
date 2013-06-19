require 'bundler/setup'
require 'leveldb'

include Leveldb

err = err_create

##
# Open
#
p :open
options = options_create
options.set_create_if_missing 1
db = open options, './tmp/testdb', err

abort err.message unless err.null?

##
# Write
#
p :write
write_opts = writeoptions_create
put(db, write_opts, "key", "value", err)

abort err.message unless err.null?

##
# Read
#
p :read
read_opts = readoptions_create
read = get(db, read_opts, "key", 3, read_len, err)

abort err.message unless err.null?
puts "Key is: #{read}"

##
# Delete
#
p :delete
delete(db, write_opts, "key", 3, err)

abort err.message unless err.null?

##
# Close
#
p :close
db.close

##
# Destroy
#
p :destroy
destroy_db(options, './tmp/testdb', err)
abort err.message unless err.null?
