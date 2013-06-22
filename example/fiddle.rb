require_relative '../lib/fiddler'

module LevelDB

  module Native
    include Fiddler

    cdef :open, VOIDP, options: VOIDP, name: CHAR, err: VOIDP
  end
end

extend LevelDB::Native
require 'irb'
IRB.start
