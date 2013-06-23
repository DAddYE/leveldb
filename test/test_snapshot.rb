require_relative './helper'

class TestSnapshot < Minitest::Test
  attr_reader :db

  def setup
    @db ||= LevelDB::DB.new './tmp/test-snapshot'
  end

  def teardown
    db.close
    db.destroy
  end

  def test_snap
    db.put 'a', 1
    db.put 'b', 2
    db.put 'c', 3

    snap = db.snapshot

    db.delete 'a'
    refute db.get 'a'

    snap.set!

    assert_equal '1', db.get('a')

    snap.reset!

    refute db.get('a')

    snap.set!

    assert_equal '1', db.get('a')
  end
end
