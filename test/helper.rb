require 'bundler/setup'
require 'leveldb'
require 'minitest/autorun'

# Create a temp directory
File.mkdir './tmp' unless File.exist?('./tmp')
