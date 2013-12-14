require 'bundler/setup'
require 'leveldb'
require 'minitest/autorun'

# Create a temp directory
Dir.mkdir './tmp' unless Dir.exist?('./tmp')
