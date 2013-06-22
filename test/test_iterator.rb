require_relative './helper'

class TestIterator < Minitest::Test
  attr_reader :db

  def setup
    @db ||= LevelDB::DB.new './tmp/test-iterator'
  end

  def teardown
    db.close
    db.destroy
  end

  def test_next
    db[:a] = :sten
    db[:b] = :roger

    iterator = db.each

    assert_equal %w[a sten],  iterator.next
    assert_equal %w[b roger], iterator.next

    assert db.each.next
    refute iterator.next
  end

  def test_reverse_next
    db[:a] = :sten
    db[:b] = :roger

    iterator = db.reverse_each

    assert_equal %w[b roger], iterator.next
    assert_equal %w[a sten],  iterator.next

    assert db.each.next
    refute iterator.next
  end

  def test_range_next
    ('a'..'z').each { |l| db[l] = l.upcase }

    range = db.range('b', 'd')

    assert_equal %w[b B], range.next
    assert_equal %w[c C], range.next
    assert_equal %w[d D], range.next

    refute range.next
  end

  def test_range_reverse_next
    ('a'..'z').each { |l| db[l] = l.upcase }

    range = db.reverse_each.range('b', 'd')

    assert_equal %w[d D], range.next
    assert_equal %w[c C], range.next
    assert_equal %w[b B], range.next

    refute range.next
  end
end
