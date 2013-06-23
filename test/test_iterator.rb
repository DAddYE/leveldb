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

    range = db.reverse_range('b', 'd')

    assert_equal %w[d D], range.next
    assert_equal %w[c C], range.next
    assert_equal %w[b B], range.next

    refute range.next
  end

  def test_keys
    db[:a] = :sten
    db[:b] = :roger

    assert_equal %w[a b], db.keys
  end

  def test_values
    db[:a] = :sten
    db[:b] = :roger

    assert_equal %w[sten roger], db.values
  end

  def test_block
    db[:a] = :sten
    db[:b] = :roger

    keys, values = [], []
    db.each { |k,v| keys.push(k); values.push(v) }

    assert_equal %w[a b], keys
    assert_equal %w[sten roger], values
  end

  def test_reverse_block
    db[:a] = :sten
    db[:b] = :roger

    keys, values = [], []
    db.reverse_each { |k,v| keys.push(k); values.push(v) }

    assert_equal %w[b a], keys
    assert_equal %w[roger sten], values
  end

  def test_range_block
    ('a'..'z').each { |l| db[l] = l.upcase }

    keys, values = [], []
    db.range('b', 'd') { |k,v| keys.push(k); values.push(v) }

    assert_equal %w[b c d], keys
    assert_equal %w[B C D], values
  end

  def test_range_reverse_block
    ('a'..'z').each { |l| db[l] = l.upcase }

    keys, values = [], []
    db.reverse_range('b', 'd') { |k,v| keys.push(k); values.push(v) }

    assert_equal %w[d c b], keys
    assert_equal %w[D C B], values
  end
end
