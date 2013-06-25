require_relative './helper'

class TestBasic < Minitest::Test
  attr_reader :db

  def setup
    @db ||= LevelDB::DB.new './tmp/test-db'
  end

  def teardown
    db.close
    db.destroy
  end

  def test_open
    assert_raises(LevelDB::DB::Error) do
      LevelDB::DB.new './doesnt-exist/foo'
    end
    assert db
  end

  def test_put
    foo = db.put(:foo, :bar)
    assert_equal 'bar', foo

    foo = db[:foo] = 'bax'
    assert_equal 'bax', foo
  end

  def test_read
    db.put(:foo, :bar)
    assert_equal 'bar', db.get(:foo)

    db[:foo] = 'bax'
    assert_equal 'bax', db[:foo]
  end

  def test_exists?
    db[:foo] = :bar

    assert db.exists?(:foo)
    assert db.includes?(:foo)
    assert db.contains?(:foo)
    assert db.member?(:foo)
    assert db.has_key?(:foo)
    refute db.exists?(:foxy)
  end

  def test_fetch
    db[:foo] = :bar

    assert_equal 'bar', db.fetch(:foo)
    assert_raises LevelDB::DB::KeyError do
      db.fetch(:sten)
    end
    assert_equal 'smith', db.fetch(:sten, :smith)
    assert_equal 'francine', db.fetch(:francine){ |key| key }
  end

  def test_delete
    db[:foo] = 'bar'

    res = db.delete(:foo)
    assert_equal 'bar', res

    res = db.delete(:foo)
    assert_nil res
  end

  def test_close
    d = LevelDB::DB.new './tmp/test-close'
    assert d.close
    assert_raises(LevelDB::DB::ClosedError){ d[:foo] }
  end

  def test_destroy
    d = LevelDB::DB.new './tmp/test-close'
    assert_raises(LevelDB::DB::Error){ d.destroy }
    assert d.close
    assert d.destroy
  end

  def test_stats
    assert_match /Level/, db.stats
  end
end
